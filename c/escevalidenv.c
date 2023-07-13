/* SPDX-License-Identifier: 0BSD */
/* Copyright 2017 Alexander Kozhevnikov <mentalisttraceur@gmail.com> */

#include <stdlib.h> /* EXIT_SUCCESS, EXIT_FAILURE, exit, getenv */

static
char * require(char required, char * string)
{
    if(*string != required)
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
        if(next == '\0')
        {
            exit(EXIT_FAILURE);
        }
        if(next == '\'')
        {
            return string + 1;
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
    unvalidated = skip_spaces(unvalidated);
    while(*unvalidated != '\0')
    {
        unvalidated = require('\'', unvalidated);
        unvalidated = require_closing_quote(unvalidated);
        if(*unvalidated == ' ')
        {
            unvalidated = skip_spaces(unvalidated);
        }
        else if(*unvalidated != '\0')
        {
            unvalidated = require('\\', unvalidated);
            unvalidated = require('\'', unvalidated);
            if(*unvalidated == '\0')
            {
                exit(EXIT_FAILURE);
            }
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
