#! /usr/bin/env bash

shopt -s globstar

# Switch to the directory containing the script so that relative paths may be
# used.
cd "${0%/*}"
files=(**/*.cc)
if [ "$1" = check ]
then
    clang-format --verbose --dry-run -Werror ${files[@]}
else
    clang-format --verbose -i ${files[@]}
fi
