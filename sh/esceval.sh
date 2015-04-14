# Copyright (C) Alexander Kozhevnikov <mentalisttraceur@gmail.com> 2015-04-14;
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public Licence as published by
# the Free Software Foundation, either version 3 of the licence or,
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for details.
# 
# You should've received a copy of the GNU General Public License
# with this program. If not, see <http://www.gnu.org/licences/>,
# or write to the Free Software Foundation, Inc.,
# 59 Temple Place, Suite 330 Boston MA 02111-1307 USA.

# On 2015-04-14, this script was compatible with Bourne and POSIX shells.
# EXCEPT for the following exceptions:
# Function declarations (some ancient Bourne shells don't support functions).
# I am currently unclear on the portability of the "type" command.

if ! type esceval > /dev/null
then
 # ${var%%word} and ${var#word} are not supported in old Bourne shells, such as
 # the /bin/sh on Solaris 10 and earlier. So first we check if that syntax is
 # working. If it is, we do the shell-only implementation. If it is not, we
 # fall back onto a sed-dependent implementation.
 if (eval 'echo ${A%%a} ${A#a}' 1>/dev/null 2>&1)
 then
  eval 'esceval()
  {
   case $# in 0) return 0; esac
   # The rest of the function is in a subshell to keep the variable definitions
   # from leaking into the shell environment this is being run in.
   (
    while true
    do
     printf "'\''"
     UNESCAPED=$1
     while true
     do
      case $UNESCAPED in
      *\'\''*)
       printf %s "${UNESCAPED%%\'\''*}"
       printf "'"'\''"'"
       UNESCAPED=${UNESCAPED#*\'\''}
       ;;
      *)
       break
      esac
     done
     printf %s "$UNESCAPED"
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
   while true
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
