/*
 * Copyright (C) Alexander Kozhevnikov <mentalisttraceur@gmail.com> 2015-01-06;
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public Licence as published by
 * the Free Software Foundation, either version 3 of the licence or,
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for details.
 * 
 * You should've received a copy of the GNU General Public License
 * with this program. If not, see <http://www.gnu.org/licences/>,
 * or write to the Free Software Foundation, Inc.,
 * 59 Temple Place, Suite 330 Boston MA 02111-1307 USA.
 */

#include <stdio.h>

int main(int argc, char * argv[])
{
 if(argc < 2)
 {
  return 0;
 }
 size_t i = 1;
 while(1)
 {
  fputc('\'', stdout);
  size_t j = 0;
  while(1)
  {
   char c = argv[i][j];
   if(c == '\'')
   {
    fputs("'\\''", stdout);
   }
   else if(c)
   {
    fputc(c, stdout);
   }
   else
   {
    break;
   }
   j += 1;
  }
  i += 1;
  if(i == argc)
  {
   fputs("'\n", stdout);
   break;
  }
  fputs("' ", stdout);
 }
 return 0;
}
