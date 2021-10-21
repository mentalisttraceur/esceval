/* SPDX-License-Identifier: 0BSD */
/* Copyright 2015 Alexander Kozhevnikov <mentalisttraceur@gmail.com> */

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
