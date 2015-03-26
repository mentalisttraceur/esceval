# Copyright (C) Alexander Kozhevnikov <mentalisttraceur@gmail.com> 2015-03-26;
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

# On 2015-03-26, this script was compatible with Bourne and POSIX shells.
# EXCEPT for the following exceptions:
# Function declarations (some ancient Bourne shells don't support functions).

esceval()
{
 while true
 do
  printf "'"
  printf %s "$1" | sed "s/'/'\\\\''/g"
  shift
  case $# in
  0)
   printf "'\n"
   break
  esac
  printf "' "
 done
}
