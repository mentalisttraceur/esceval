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

#include <stdio.h> /* fputs, fputc, EOF */
#include <stdlib.h> /* EXIT_SUCCESS, EXIT_FAILURE, exit */

static
void fail_on_eof(int result)
{
 if(result == EOF)
 {
  exit(EXIT_FAILURE);
 }
}

int main(int argc, char * * argv)
{
 char * arg;
 if(argc < 2)
 {
  return 0;
 }
 argv += 1;
 fail_on_eof(fputc('\'', stdout));
 while(1)
 {
  arg = *argv;
  while(1)
  {
   char c = *arg;
   if(c == '\'')
   {
    fail_on_eof(fputs("'\\''", stdout));
   }
   else if(c)
   {
    fail_on_eof(fputc(c, stdout));
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
  fail_on_eof(fputs("' '", stdout));
 }
 fail_on_eof(fputs("'\n", stdout));
 fail_on_eof(fflush(stdout));
 return EXIT_SUCCESS;
}
