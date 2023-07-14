# SPDX-License-Identifier: 0BSD
# Copyright 2023 Alexander Kozhevnikov <mentalisttraceur@gmail.com>

# Mutates: $unvalidated
_escevalid_quoted_string()
{
    case $unvalidated in \'*) :;; *)
        return 1
    esac
    unvalidated=${unvalidated#\'}
    while :
    do
        case $unvalidated in
        \'*)
            unvalidated=${unvalidated#\'}
            return 0
        ;;
        '')
            return 1
        ;;
        *)
            unvalidated=${unvalidated#?}
        esac
    done
}

# Mutates: $unvalidated
_escevalid_backslash_quote()
{
    case $unvalidated in
    "\'"*)
        unvalidated=${unvalidated#"\'"}
        return 0
    ;;
    *)
        return 1
    esac
}

# Mutates: $unvalidated
_escevalid_spaces()
{
    case $unvalidated in ' '*) :;; *)
        return 1
    esac
    while :
    do
        case $unvalidated in
        ' '*)
            unvalidated=${unvalidated#' '}
        ;;
        *)
            return 0
        esac
    done
}

escevalidenv()
(
    for name
    do
        unvalidated=`printenv "$name" || :`
        while :
        do
            case $unvalidated in '') break; esac
            if ! _escevalid_quoted_string \
            && ! _escevalid_backslash_quote \
            && ! _escevalid_spaces
            then
                exit 1
            fi
        done
    done
)

escevalidenv "$@"
