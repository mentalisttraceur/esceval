/* SPDX-License-Identifier: 0BSD */
/* Copyright 2017 Alexander Kozhevnikov <mentalisttraceur@gmail.com> */

#include <stdlib.h> /* EXIT_SUCCESS, EXIT_FAILURE, getenv */

static
int escevalid_quoted_string(char * * unvalidated)
{
    char * string = *unvalidated;
    if(*string != '\'')
    {
        return 0;
    }
    string += 1;
    for(;;)
    {
        char next = *string;
        if(next == '\'')
        {
            *unvalidated = string + 1;
            return 1;
        }
        else if(next == '\0')
        {
            return 0;
        }
        string += 1;
    }
}

static
int escevalid_backslash_quote(char * * unvalidated)
{
    char * string = *unvalidated;
    if(*string != '\\')
    {
        return 0;
    }
    string += 1;
    if(*string != '\'')
    {
        return 0;
    }
    *unvalidated = string + 1;
    return 1;
}

static
int escevalid_spaces(char * * unvalidated)
{
    char * string = *unvalidated;
    int matched = 0;
    while(*string == ' ')
    {
        matched = 1;
        string += 1;
    }
    *unvalidated = string;
    return matched;
}

static
int escevalid(char * unvalidated)
{
    while(*unvalidated != '\0')
    {
        if(!escevalid_quoted_string(&unvalidated)
        && !escevalid_backslash_quote(&unvalidated)
        && !escevalid_spaces(&unvalidated))
        {
            return 0;
        }
    }
    return 1;
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
        if(!escevalid(env))
        {
            return EXIT_FAILURE;
        }
    }
    return EXIT_SUCCESS;
}
