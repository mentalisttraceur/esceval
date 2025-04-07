# esceval - *Esc*ape *Eval*uation

`esceval` is a couple small CLI tools that let us:

1. Escape strings so that they evaluate back to the
   same string in all Bourne-like/POSIX shells.

2. Safely check if arbitrary strings are in
   "esceval format" before evaluating them.


## Usage

#### 1. `esceval`

`esceval` quotes/escapes all arguments it receives and
prints them on standard output, separated by spaces:

```sh
$ esceval foo 'bar  qux' "abc'def" "'zyx'''wvu'"
'foo' 'bar  qux' 'abc'\''def' \''zyx'\'\'\''wvu'\'
```

#### 2. `escevalcheck`

`escevalcheck` checks each of its arguments - if any
of them is not a validly esceval-formatted string,
exit status is `1`; otherwise, exit status is `0`.

```sh
$ escevalcheck "'foo' 'bar  qux' 'abc'\''def' \''zyx'\'\'\''wvu'\'"; echo $?
0
$ escevalcheck "'foo"; echo $?  # note the missing closing quote
1
```

#### 3. `escevalenv` and `escevalcheckenv`

`escevalenv` and `escevalcheckenv` are the same
as `esceval` and `escevalcheck`, but they take
environment variable names as arguments:

```sh
$ escevalenv PATH
'/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
```

When handling sensitive data (private or identifying
information, cryptographic keys, passwords, and so on),

```sh
x="$SECRET" escevalenv x
```

is more secure than

```sh
esceval "$SECRET"
```

since on most operating systems, environment variables are
kept more private from other processes than arguments.

If a given environment variable is not set, `escevalenv` and
`escevalcheckenv` treat it as if it's set to the empty string:

```sh
$ escevalenv EXAMPLE_NAME_WHICH_IS_NOT_SET
''
$ escevalcheckenv EXAMPLE_NAME_WHICH_IS_NOT_SET; echo $?
0
```


## Example

A portable `pushd` and `popd` in just a few lines:

```sh
DIRECTORY_STACK="$(esceval "$(pwd)")"

pushd()
{
    cd "$1" &&
    DIRECTORY_STACK="$(esceval "$1") $DIRECTORY_STACK"
}

popd()
{
    if ! escevalcheck "$DIRECTORY_STACK"
    then
        printf '%s\n' 'popd: directory stack corrupted' 1>&2
        return 1
    fi
    eval "_popd $DIRECTORY_STACK"
}

_popd()
{
    if [ "$#" -lt 2 ]
    then
        printf '%s\n' 'popd: directory stack empty' 1>&2
        return 1
    fi
    shift
    DIRECTORY_STACK="$(esceval "$@")"
    cd "$1" && pwd
}
```


## Lists, Stacks, Queues

`esceval` (combined with `eval`, a shell function or
`set --`, and `shift`) makes it really easy to write
shell scripts which work with lists, stacks, and queues,
even on shells without native arrays.

The above example shows how we can implement stack
push and pop. For FIFO queue behavior, we just
need to append the new esceval'd values instead of
prepending them.

(Of course, these are still O(n) operations, not
O(1) like we'd get from native stacks and queues,
because the shell has to evaluate the string each
time, but this gets us much of the simplicity,
ease, and code clarity of those data structures.)


## Versus `printf`'s `%q`

If you just want an unambiguous echo for debugging,
logging, or error messages, `printf` with `%q` may
be better at revealing stray control characters,
differences in whitespace, and so on. (At least in
shells like `bash` and `zsh`, where `%q` can print
escape sequences like `$'\t'`).

If you need outputs that can be parsed back to the
same value by all Bourne-like/POSIX shells, and are
simple to verify as safe to evaluate, use `esceval`.


## `esceval` Format Specification

1. A single-quote (`'`) is encoded as a
   backslash and then a single-quote (`\'`).

2. Any characters other than single-quotes are
   encoded by wrapping them in single-quotes.
   (For example, `abc` is encoded as `'abc'`.)

3. The empty string is encoded as `''`.

4. Strings are separated by one or more spaces (` `).
   
(Command-line implementations of `esceval` should
write a newline after the last string for convenience,
but this is not part of the `esceval` format, and
`escevalcheck` implementations must reject unencoded
newlines, because shells parse newlines as the end
of a command.)

Redundant encodings (for example, encoding `a''b`
into `'a'\'''\''b'` instead of `'a'\'\''b'`) are
permitted to allow very simple implementations.
