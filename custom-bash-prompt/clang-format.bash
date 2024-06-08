#! /usr/bin/env bash

shopt -s globstar

cd "${0%/*}"
files=(**/*.c)
if [ "$1" = check ]
then
    clang-format --verbose --dry-run --Werror ${files[@]}
else
    clang-format --verbose -i ${files[@]}
fi
