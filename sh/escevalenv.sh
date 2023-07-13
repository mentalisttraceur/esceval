# SPDX-License-Identifier: 0BSD
# Copyright 2017 Alexander Kozhevnikov <mentalisttraceur@gmail.com>

case `x= escevalenv x 2>&1 || :` in "''") :;; *)
    escevalenv()
    (
        case $# in 0) exit 0; esac
        while :
        do
            escaped=\'
            unescaped=`printenv "$1" || :`
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
esac

escevalenv "$@"
