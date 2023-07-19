#!/bin/sh -
# SPDX-License-Identifier: 0BSD
# Copyright 2023 Alexander Kozhevnikov <mentalisttraceur@gmail.com>

# Mutates: $unvalidated
_escevalcheck_quoted_string()
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
_escevalcheck_backslash_quote()
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
_escevalcheck_spaces()
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

escevalcheck()
(
    for unvalidated
    do
        while :
        do
            case $unvalidated in '') break; esac
            if ! _escevalcheck_quoted_string \
            && ! _escevalcheck_backslash_quote \
            && ! _escevalcheck_spaces
            then
                exit 1
            fi
        done
    done
)

escevalcheck "$@"
