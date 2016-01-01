# Copyright (C) 2015-02-24 Alexander Kozhevnikov <mentalisttraceur@gmail.com>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

# On 2016-01-01, this script was compatible with Bourne and POSIX shells.
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
     printf "'\''"
     unescaped=$1
     while :
     do
      case $unescaped in
      *\'\''*)
       printf %s "${unescaped%%\'\''*}""'"'\''"'"
       unescaped=${unescaped#*\'\''}
       ;;
      *)
       break
      esac
     done
     printf %s "$unescaped"
     shift
     case $# in 0) break; esac
     printf "'\'' "
    done
    printf "'\''\n"
   )
  }'
 else
  esceval()
  {
   case $# in 0) return 0; esac
   while :
   do
    printf "'"
    printf %s "$1" | sed "s/'/'\\\\''/g"
    shift
    case $# in 0) break; esac
    printf "' "
   done
   printf "'\n"
  }
 fi
fi
