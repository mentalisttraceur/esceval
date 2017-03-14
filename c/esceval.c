/*****************************************************************************\
 * Copyright (C) 2015-02-24 Alexander Kozhevnikov <mentalisttraceur@gmail.com>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted.
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

int main(int argc, char * * argv)
{
 char * arg;
 if(argc < 2)
 {
  return 0;
 }
 argv += 1;
 fputc('\'', stdout);
 while(1)
 {
  arg = *argv;
  while(1)
  {
   char c = *arg;
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
   arg += 1;
  }
  argv += 1;
  if(!*argv)
  {
   break;
  }
  fputs("' '", stdout);
 }
 fputs("'\n", stdout);
 return 0;
}
