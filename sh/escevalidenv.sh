# SPDX-License-Identifier: 0BSD
# Copyright 2023 Alexander Kozhevnikov <mentalisttraceur@gmail.com>

# Mutates: $unvalidated
_escevalid_skip_spaces()
{
    while :
    do
        case $unvalidated in
        ' '*)
            unvalidated=${unvalidated#' '}
        ;;
        *)
            break
        esac
    done
}

# Mutates: $unvalidated
# Exits current (sub)shell if there is no closing quote.
_escevalid_require_closing_quote()
{
    while :
    do
        case $unvalidated in
        \'*)
            unvalidated=${unvalidated#\'}
            break
        ;;
        '')
            exit 1
        ;;
        *)
            unvalidated=${unvalidated#?}
        esac
    done
}

# Mutates: $unvalidated
# Exits current (sub)shell if the next character is not the required one.
_escevalid_require()
{
    case $unvalidated in
    "$1"*)
        unvalidated=${unvalidated#"$1"}
    ;;
    *)
        exit 1
    esac
}

escevalidenv()
(
    for name
    do
        unvalidated=`printenv "$name" || :`
        _escevalid_skip_spaces
        while :
        do
            case $unvalidated in '') break; esac
            _escevalid_require \'
            _escevalid_require_closing_quote
            case $unvalidated in
            ' '*)
                _escevalid_skip_spaces
            ;;
            ?*)
                _escevalid_require \\
                _escevalid_require \'
                case $unvalidated in '') exit 1; esac
            esac
        done
    done
)

escevalidenv "$@"
