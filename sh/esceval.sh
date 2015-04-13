# Copyright (C) Alexander Kozhevnikov <mentalisttraceur@gmail.com> 2015-04-07;
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

# On 2015-04-13, this script was compatible with Bourne and POSIX shells.
# EXCEPT for the following exceptions:
# Function declarations (some ancient Bourne shells don't support functions).
# ${var%%word} is not supported in some shells (e.g. Solaris 10 /bin/sh).
# ${var#word} is not supported in some shells (e.g. Solaris 10 /bin/sh).
# I am currently unclear on the portability of the "type" command.

if ! type esceval > /dev/null
then
 esceval()
 {
  case $# in 0) return 0; esac
  (
   while true
   do
    printf "'"
    UNESCAPED=$1
    while true
    do
     case $UNESCAPED in
     *\'*)
      printf %s "${UNESCAPED%%\'*}"
      printf "'\''"
      UNESCAPED=${UNESCAPED#*\'}
      ;;
     *)
      break
     esac
    done
    printf %s "$UNESCAPED"
    shift
    case $# in 0) break; esac
    printf "' "
   done
   printf "'\n"
  )
 }
fi
