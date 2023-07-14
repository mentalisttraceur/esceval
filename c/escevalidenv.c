/* SPDX-License-Identifier: 0BSD */
/* Copyright 2017 Alexander Kozhevnikov <mentalisttraceur@gmail.com> */

#include <stdlib.h> /* EXIT_SUCCESS, EXIT_FAILURE, exit, getenv */

static
char * require_quote(char * string)
{
    if(*string != '\'')
    {
        exit(EXIT_FAILURE);
    }
    return string + 1;
}

static
char * require_closing_quote(char * string)
{
    for(;;)
    {
        char next = *string;
        if(next == '\'')
        {
            return string + 1;
        }
        else if(next == '\0')
        {
            exit(EXIT_FAILURE);
        }
        string += 1;
    }
}

static
char * skip_spaces(char * string)
{
    while(*string == ' ')
    {
        string += 1;
    }
    return string;
}

static
void escevalid(char * unvalidated)
{
    while(*unvalidated != '\0')
    {
        if(*unvalidated == '\'')
        {
            unvalidated = require_closing_quote(unvalidated + 1);
        }
        else if(*unvalidated == '\\')
        {
            unvalidated = require_quote(unvalidated + 1);
        }
        else if(*unvalidated == ' ')
        {
            unvalidated = skip_spaces(unvalidated + 1);
        }
        else
        {
            exit(EXIT_FAILURE);
        }
    }
}

int main(int argc, char * * argv)
{
    char * arg;
    char * env;
    if(argc < 2)
    {
        return EXIT_SUCCESS;
    }
    argv += 1;
    while((arg = *argv++))
    {
        env = getenv(arg);
        if(!env)
        {
            env = "";
        }
        escevalid(env);
    }
    return EXIT_SUCCESS;
}
