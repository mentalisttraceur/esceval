/*****************************************************************************\
 * Copyright (C) 2015, 2017 Alexander Kozhevnikov <mentalisttraceur@gmail.com>
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

#include <stdio.h> /* EOF, fputc, fputs, perror */
#include <stdlib.h> /* EXIT_FAILURE, EXIT_SUCCESS, exit */

static
void fail_if_eof(int result, char * arg0)
{
 if(result == EOF)
 {
  perror(arg0);
  exit(EXIT_FAILURE);
 }
}

int main(int argc, char * * argv)
{
 char * arg0 = *argv;
 if(argc < 2)
 {
  return EXIT_SUCCESS;
 }
 argv += 1;
 fail_if_eof(fputc('\'', stdout), arg0);
 for(;;)
 {
  char * arg = *argv;
  for(;;)
  {
   char c = *arg;
   if(c == '\'')
   {
    fail_if_eof(fputs("'\\''", stdout), arg0);
   }
   else if(c)
   {
    fail_if_eof(fputc(c, stdout), arg0);
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
  fail_if_eof(fputs("' '", stdout), arg0);
 }
 fail_if_eof(fputs("'\n", stdout), arg0);
 fail_if_eof(fflush(stdout), arg0);
 return EXIT_SUCCESS;
}
