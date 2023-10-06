import shlex
import subprocess

from hypothesis import given
from hypothesis.strategies import binary, composite, just, lists, one_of
import pytest


# Hypothesis strategies:

# The null character is excluded because the low-level C-style interface
# between/in most OSs and programs will treat it as the end of that string:
valid_strings = binary().map(lambda x: x.replace(b'\0', b''))

# Same as the above strategy, but the single-quote (`'`) is excluded;
# a basis for strategies where we control where single-quotes occur:
valid_strings_minus_quotes = valid_strings.map(lambda x: x.replace(b"'", b''))

# Valid single-quoted strings (`'...'`):
quoted_strings = valid_strings_minus_quotes.map(lambda x: b"'" + x + b"'")

backslashed_quotes = just(b"\\'")

spaces = lists(just(b' '), min_size=1).map(b''.join)

# All possible valid esceval-escaped substrings:
escaped_strings = lists(one_of(
    quoted_strings, backslashed_quotes, spaces
)).map(b''.join)

# Now for strings which are not valid esceval-escaped strings.
#
# A key point is that we can't just generate anything that might
# not be valid, since invalidities could cancel each other out. For
# example, if we generate `\` and `'''`, which are both invalid,
# their catenation is valid (`\'''` is a redundant encoding of `'`);
# for another example, if we have two valid tokens separated by
# spaces, such as `'ab' 'cd'` and we allowed both to be permuted
# into invalidity, we could end up with valid redundant encodings
# like `'ab'' ''cd'` or `'ab'' cd'`.
#
# So it's much simpler/easier to just do the strategies which will
# reliably generate exactly one thing that makes the string invalid
# and nothing after that which could restore it back to validity.

unquoted_strings = valid_strings_minus_quotes.filter(lambda x: len(x) > 0)

@composite
def invalid_nested_quotes(draw):
    # Grab two byte strings that can validly go inside single-quotes:
    substring1 = draw(valid_strings_minus_quotes)
    substring2 = draw(valid_strings_minus_quotes)
    # Build a final string which is guaranteed to be invalid
    # by containing at least one unescaped nested quote:
    return b"'" + substring1 + b"'" + substring2 + b"'"

# esceval only uses backslash on single-quote characters:
invalid_backslashes = unquoted_strings.map(lambda x: b'\\' + x[0:1])

invalid_strings_by_themselves = one_of(
    unquoted_strings,
    invalid_nested_quotes(),
    invalid_backslashes,
)

# Also, invalid strings might start with valid escaped substrings.
#
# We might be tempted to think that we could start with an invalid
# string and then end it with a valid string, but... not exactly.
# In a sense, it is inherent to simple encodings like string quoting
# that there is only ever one error - either a missing closing quote,
# or junk after the closing quote (failure to escape a nested quote
# is just the junk-after-a-closing-quote case from a parsing view).
# Applying that to invalid-string generation: a valid string
# catenated after an invalid string could restore validity (while
# changing the interpretation of the valid suffix). For example,
# `'''` is invalid, and `\'` is a valid backslash-escaping of a
# single-quote, but if we catenate them, we get `'''\'`, which
# parses validly (`''`, which is a redundant encoding of nothing,
# followed by `'\'`, which is a valid single-quoting of a backslash).
# Yet another way to see this: we can reliably produce an invalid
# string by removing the last character of a valid quoted string,
# but removing the first character might produce another invalid
# string (for example, `\''\'` is a valid encoding of `'\`, and
# `''\'` is a valid but redundant encoding of `'`).
@composite
def _invalid_strings(draw):
    return draw(escaped_strings) + draw(invalid_strings_by_themselves)

invalid_strings = _invalid_strings()

valid_or_invalid = lists(one_of(escaped_strings, invalid_strings))

@composite
def lists_of_strings_at_least_one_invalid(draw):
    # What we really want is to tell Hypothesis: "give me a list
    # made up from valid and/or invalid strings, which must have
    # at least one invalid string in it", but there's no built-in
    # strategy for that, so we have to do it by-hand:
    #
    # 1. Grab one invalid string - this ensures the "at least one" part:
    invalid_string = draw(invalid_strings)
    # 2. Grab two lists of strings, which could be zero-length, and
    #    could have as little as zero invalid strings:
    strings1 = draw(valid_or_invalid)
    strings2 = draw(valid_or_invalid)
    # 3. Now we combine them into one list. Due to the points in #2,
    #    the combined list could randomly get more than the one
    #    invalid string, and in the smallest example case it's just
    #    the one invalid string without anything on either end.
    return [*strings1, invalid_string, *strings2]


# Wrappers to invoke esceval:
# Assumes that
# 1. `make c` has been run (implied by `make test`)
#    so that the C compiled binaries are present.
# 2. `pytest test.py` is executed from inside the
#    base of this repo's directory, so that the
#    relative paths to the executables work.

def _run(program, arguments, environment=None):
    result = subprocess.run(
        [program, *arguments],
        capture_output=True,
        check=True,
        env=environment,
    )
    assert result.stderr == b''
    return result.stdout.removesuffix(b'\n')

def _run_env(program, strings):
    # For the `*env` programs, pass arguments as environment variables,
    # and pass the names of those environment variables as arguments:
    arguments = []
    environment = {}
    for index, string in enumerate(strings):
        name = f'a{index}' 
        arguments.append(name)
        environment[name] = string
    return _run(program, arguments, environment)

def c_esceval(strings):
    return _run('./esceval', strings)

def c_escevalcheck(strings):
    return _run('./escevalcheck', strings)

def c_escevalenv(strings):
    return _run_env('./escevalenv', strings)

def c_escevalcheckenv(strings):
    return _run_env('./escevalcheckenv', strings)

def sh_esceval(strings):
    return _run('sh/esceval.sh', strings)

def sh_escevalcheck(strings):
    return _run('sh/escevalcheck.sh', strings)

def sh_escevalenv(strings):
    return _run_env('sh/escevalenv.sh', strings)

def sh_escevalcheckenv(strings):
    return _run_env('sh/escevalcheckenv.sh', strings)


# Tests

# Verify that escevalcheck accepts valid strings
# (and the nil case of no strings):

@given(lists(escaped_strings))
def test_c_escevalcheck_accept(strings):
    c_escevalcheck(strings)

@given(lists(escaped_strings))
def test_c_escevalcheckenv_accept(strings):
    c_escevalcheckenv(strings)

@given(lists(escaped_strings))
def test_sh_escevalcheck_accept(strings):
    sh_escevalcheck(strings)

@given(lists(escaped_strings))
def test_sh_escevalcheckenv_accept(strings):
    sh_escevalcheckenv(strings)

# Verify that escevalcheck rejects invalid strings:

@given(lists_of_strings_at_least_one_invalid())
def test_c_escevalcheck_reject(strings):
    with pytest.raises(subprocess.CalledProcessError):
        c_escevalcheck(strings)

@given(lists_of_strings_at_least_one_invalid())
def test_c_escevalcheckenv_reject(strings):
    with pytest.raises(subprocess.CalledProcessError):
        c_escevalcheckenv(strings)

@given(lists_of_strings_at_least_one_invalid())
def test_sh_escevalcheck_reject(strings):
    with pytest.raises(subprocess.CalledProcessError):
        sh_escevalcheck(strings)

@given(lists_of_strings_at_least_one_invalid())
def test_sh_escevalcheckenv_reject(strings):
    with pytest.raises(subprocess.CalledProcessError):
        sh_escevalcheckenv(strings)

# Verify that esceval produces strings that escevalcheck accepts:

def _test_esceval_escevalcheck(esceval, strings):
    escaped = esceval(strings)
    # In principle, the above tests have validated all escevalcheck
    # variants to the same exacting standard, so we could test
    # against just one of the faster variants here, buying more
    # fuzzing time and/or a faster change-test feedback loop.
    # On the other hand, testing against all four helps interlock
    # the correctness of each piece - for the above tests to fail,
    # just the escevalcheck implementations and the test code has to
    # be wrong, but for this to fail, the esceval implementations
    # all have to be wrong too. It also doesn't actually add much
    # time to the test execution to test all four.
    c_escevalcheck([escaped])
    c_escevalcheckenv([escaped])
    sh_escevalcheck([escaped])
    sh_escevalcheckenv([escaped])

@given(lists(valid_strings))
def test_c_esceval_escevalcheck(strings):
    _test_esceval_escevalcheck(c_esceval, strings)

@given(lists(valid_strings))
def test_c_escevalenv_escevalcheck(strings):
    _test_esceval_escevalcheck(c_escevalenv, strings)

@given(lists(valid_strings))
def test_sh_esceval_escevalcheck(strings):
    _test_esceval_escevalcheck(sh_esceval, strings)

@given(lists(valid_strings))
def test_sh_escevalenv_escevalcheck(strings):
    _test_esceval_escevalcheck(sh_escevalenv, strings)

# Verify that esceval produces strings that evaluate back to the same data:

def _test_esceval_correct_data(esceval, strings):
    escaped = esceval(strings)
    # The ideal test here is `sh_evaluate(escaped) == strings`,
    # where `sh_evaluate` is done by a Bourne-like/POSIX shell,
    # but it's really awkward/clunky/verbose to go through the
    # external shell - luckily, Python has `shlex.split`, and
    # that works well enough. Sadly, `shlex` works on (unicode)
    # strings, not byte strings. So we have to decode the bytes
    # into a Python string, `shlex.split` them, and then encode
    # the split strings back to bytes. Any encoding will do so
    # long as Python's implementation of it can round-trip raw
    # binary without change/loss:
    escaped_as_string = escaped.decode('latin1')
    split_as_strings = shlex.split(escaped_as_string)
    split = list(map(lambda s: s.encode('latin1'), split_as_strings))
    assert strings == split

@given(lists(valid_strings))
def test_c_esceval_correct_data(strings):
    _test_esceval_correct_data(c_esceval, strings)

@given(lists(valid_strings))
def test_c_escevalenv_correct_data(strings):
    _test_esceval_correct_data(c_escevalenv, strings)

@given(lists(valid_strings))
def test_sh_esceval_correct_data(strings):
    _test_esceval_correct_data(sh_esceval, strings)

@given(lists(valid_strings))
def test_sh_escevalenv_correct_data(strings):
    _test_esceval_correct_data(sh_escevalenv, strings)


