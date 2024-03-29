#!/bin/sh -
# SPDX-License-Identifier: 0BSD
# Copyright 2017 Alexander Kozhevnikov <mentalisttraceur@gmail.com>

# Mutates: $escaped $unescaped
_esceval()
{
    case $unescaped in
    '')
        escaped="''"
    esac
    while :
    do
        case $unescaped in
        '')
            break
        ;;
        \'*)
            case $escaped in *[!\'])
                escaped=$escaped\'
            esac
            escaped=$escaped"\'"
            unescaped=${unescaped#\'}
        ;;
        *\'*)
            case $escaped in '' | ?*\')
                escaped=$escaped\'
            esac
            escaped=$escaped${unescaped%%\'*}"'\'"
            unescaped=${unescaped#*\'}
        ;;
        *)
            case $escaped in '' | ?*\')
                escaped=$escaped\'
            esac
            escaped=$escaped$unescaped\'
            break
        esac
    done
}

escevalenv()
(
    case $# in 0) return 0; esac
    while :
    do
        unescaped=`{ printenv "$1" && echo x; } || :`
        unescaped=${unescaped%?x}
        escaped=
        _esceval
        shift
        case $# in 0) break; esac
        printf '%s ' "$escaped" || exit 1
    done
    printf '%s\n' "$escaped" || exit 1
)

escevalenv "$@"
