/*****************************************************************************\
 * Copyright (C) 2015-02-24 Alexander Kozhevnikov <mentalisttraceur@gmail.com>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
\*****************************************************************************/

#include <stdio.h>

int main(int argc, char * argv[])
{
 if(argc < 2)
 {
  return 0;
 }
 size_t i = 1;
 fputc('\'', stdout);
 while(1)
 {
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
   break;
  }
  fputs("' '", stdout);
 }
 fputs("'\n", stdout);
 return 0;
}
