# Copyright (C) 2014, 2015, 2017, 2019
# Alexander Kozhevnikov <mentalisttraceur@gmail.com>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

# On 2019-04-25, this script was compatible with Bourne and POSIX shells.
# EXCEPT for the following exceptions:
# Function declarations (First appeared in SVR2 Bourne shells in 1984).
# command built-in (not supported in really old Bourne shells)

if command -v esceval 1>/dev/null 2>&1
then
 :
else
 if (eval 'echo ${A%%a} ${A#a}' 1>/dev/null 2>&1)
 then
  eval 'esceval()
  {
   case $# in 0) return 0; esac
   (
    while :
    do
     escaped=\'\''
     unescaped=$1
     while :
     do
      case $unescaped in
      *\'\''*)
       escaped=$escaped${unescaped%%\'\''*}"'"'\''"'"
       unescaped=${unescaped#*\'\''}
       ;;
      *)
       break
      esac
     done
     escaped=$escaped$unescaped\'\''
     shift
     case $# in 0) break; esac
     printf "%s " "$escaped" || return $?
    done
    printf "%s\n" "$escaped"
   )
  }'
 else
  esceval()
  {
   case $# in 0) return 0; esac
   (
    b='\\'
    while :
    do
     escaped=`
      printf '%s\n' "$1" \
      | sed "
         s/'/'$b''/g
         1 s/^/'/
         $ s/$/'/
        "
     ` || return $?
     shift
     case $# in 0) break; esac
     printf '%s ' "$escaped" || return $?
    done
    printf '%s\n' "$escaped"
   )
  }
 fi
fi
