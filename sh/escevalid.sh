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
# Exits current (sub)shell if the next character is not a quote.
_escevalid_require_quote()
{
    case $unvalidated in
    \'*)
        unvalidated=${unvalidated#\'}
    ;;
    *)
        exit 1
    esac
}

escevalid()
(
    for unvalidated
    do
        while :
        do
            case $unvalidated in
            '')
                break
            ;;
            \'*)
                unvalidated=${unvalidated#\'}
                _escevalid_require_closing_quote
            ;;
            \\*)
                unvalidated=${unvalidated#\\}
                _escevalid_require_quote
            ;;
            ' '*)
                unvalidated=${unvalidated#' '}
                _escevalid_skip_spaces
            ;;
            *)
                exit 1
            esac
        done
    done
)

escevalid "$@"
