/* SPDX-License-Identifier: 0BSD */
/* Copyright 2017 Alexander Kozhevnikov <mentalisttraceur@gmail.com> */

#include <stdio.h> /* EOF, fflush, fputc, fputs, perror */
#include <stdlib.h> /* EXIT_FAILURE, EXIT_SUCCESS, exit, getenv */

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
int esceval_fput_quotes(unsigned int count, FILE * output)
{
    if(count == 1)
    {
        if(fputs("\\'", output) == EOF)
        {
            return EOF;
        }
    }
    else
    if(count > 1)
    {
        if(fputc('"', output) == EOF)
        {
            return EOF;
        }
        while(count--)
        {
            if(fputc('\'', output) == EOF)
            {
                return EOF;
            }
        }
        if(fputc('"', output) == EOF)
        {
            return EOF;
        }
    }
    return 0;
}

static
int esceval(char * unescaped, FILE * output)
{
    char next = *unescaped;
    unsigned int quotes = 0;
    if(next == '\0')
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
                quotes += 1;
                if(quotes == -1)
                {
                    if(esceval_fput_quotes(quotes, output) == EOF)
                    {
                        return EOF;
                    }
                    quotes = 0;
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
            if(next == '\0')
            {
                if(esceval_fput_quotes(quotes, output) == EOF)
                {
                    return EOF;
                }
                return 0;
            }
        }
        else
        if(current == '\'')
        {
            quotes += 1;
            if(esceval_fput_quotes(quotes, output) == EOF)
            {
                return EOF;
            }
            quotes = 0;
            if(fputc('\'', output) == EOF)
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
        char * env = getenv(*argv);
        if(!env)
        {
            env = "";
        }
        fail_if_eof(esceval(env, stdout), arg0);
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
