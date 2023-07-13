# SPDX-License-Identifier: 0BSD
# Copyright 2014 Alexander Kozhevnikov <mentalisttraceur@gmail.com>

esceval()
(
    case $# in 0) exit 0; esac
    while :
    do
        escaped=\'
        unescaped=$1
        while :
        do
            case $unescaped in
            *\'*)
                escaped=$escaped${unescaped%%\'*}"'\''"
                unescaped=${unescaped#*\'}
            ;;
            *)
                break
            esac
        done
        escaped=$escaped$unescaped\'
        shift
        case $# in 0) break; esac
        printf '%s ' "$escaped" || exit 1
    done
    printf '%s\n' "$escaped" || exit 1
)

esceval "$@"
