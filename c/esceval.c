/* SPDX-License-Identifier: 0BSD */
/* Copyright 2015 Alexander Kozhevnikov <mentalisttraceur@gmail.com> */

#include <stdio.h> /* EOF, fflush, fputc, fputs, perror */
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

static
int esceval(char * unescaped, FILE * output)
{
    char next = *unescaped;
    if(!next)
    {
        return fputs("''", output);
    }
    else if(next != '\'')
    {
        if(fputc('\'', output) == EOF)
        {
            return EOF;
        }
    }
    for(;;)
    {
        char current = next;
        unescaped += 1;
        next = *unescaped;
        if(next == '\'' || !next)
        {
            if(current == '\'')
            {
                if(fputs("\\'", output) == EOF)
                {
                    return EOF;
                }
            }
            else
            {
                if(fputc(current, output) == EOF
                || fputc('\'', output) == EOF)
                {
                    return EOF;
                }
            }
            if(!next)
            {
                return 0;
            }
        }
        else
        if(current == '\'')
        {
            if(fputs("\\''", output) == EOF)
            {
                return EOF;
            }
        }
        else
        {
            if(fputc(current, output) == EOF)
            {
                return EOF;
            }
        }
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
    for(;;)
    {
        char * arg = *argv;
        fail_if_eof(esceval(arg, stdout), arg0);
        argv += 1;
        if(!*argv)
        {
            break;
        }
        fail_if_eof(fputc(' ', stdout), arg0);
    }
    fail_if_eof(fputc('\n', stdout), arg0);
    fail_if_eof(fflush(stdout), arg0);
    return EXIT_SUCCESS;
}
