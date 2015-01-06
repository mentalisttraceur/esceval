# Copyright (C) Alexander Kozhevnikov 2015-01-06;
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

# On 2015-01-06, this script was compatible with Bourne and POSIX shells.

escapeEval()
{
 while true
 do
  printf "'"
  printf %s "$1" | sed "s/'/'\\\\''/g"
  shift
  if [ $# = 0 ]
  then
   printf "'\n"
   break
  else
   printf "' "
  fi
 done
}
