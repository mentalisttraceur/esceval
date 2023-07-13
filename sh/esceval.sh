# SPDX-License-Identifier: 0BSD
# Copyright 2014 Alexander Kozhevnikov <mentalisttraceur@gmail.com>

case `esceval '' 2>&1 || :` in "''") :;; *)
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
            printf '%s ' "$escaped" || return $?
        done
        printf '%s\n' "$escaped"
    )
esac

esceval "$@"
