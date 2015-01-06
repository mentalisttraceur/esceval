/*
 * Copyright (C) Alexander Kozhevnikov 2015-01-06;
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

/* This program adds one layer of Bourne/POSIX shell escaping around every
argument passed to it (each argument is escaped individually, to preserve the
boundary between arguments). */
/* Specifically, it prints a single quote before each argument, then prints all
characters of the argument verbatim, except for single quotes, for which it
prints a single quote, a backslash, and two more single quotes. Then it prints
a final single quote and a space (to separate the arguments from each other).
To make the output more legible when used interactively, it prints a trailing
newline. Since Bourne/POSIX shells strip off ALL trailing newlines when doing
command substitution, it won't in practice effect the usecases where this tool
is needed. Similarly, the trailing space behind the last argument is unneeded,
 */

#include <stdio.h>

int main(int argc, char * argv[])
{
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
