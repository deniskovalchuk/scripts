#!/bin/bash
#######################################################################
# Script for creating a workspace C/C++                               #
#                                                                     #
# Usage: ./create_cws                                                 #
#          -d=dir_name  - name of a workspace                         #
#          -e=file_name - name of execute file                        #
#          -t=type_pr   - type project (c or c++)                     #
#                                                                     #
# Copyright (c) 2017, Denis Kovalchuk <deniskk25@gmail.com>           #
#                                                                     #  
# This code is licensed under a MIT-style license.                    #  
#######################################################################

if [[ $# -gt 3 ]]
then
    echo "Incorrect number of arguments."
    exit 1
fi
    
dir_name="project"
file_name="main"
lingua_flag="c"
current_year=$(date +"%Y")

function set_argv {
    case "$1" in
        -d=*)
            dir_name=${1:3}
            ;;
        -e=*)
            file_name=${1:3}
            ;;
        -t=*)
            lingua_flag=${1:3}
            ;;
    esac
}

for argument in $*
do
    set_argv $argument
done

case $lingua_flag in
    "c")
        include_source="#include <stdlib.h>\n#include <stdio.h>"
        compl="gcc"
        compl_flags="-c -g -Wall"
        ;;
    "cpp")
        include_source="#include <iostream>\n\nusing namespace std;"
        compl="g++"
        compl_flags="-c -g -Wall -std=c++14"
        ;;
    *)
        echo "Wrong lingua flag."
        exit 1
        ;;
esac

#
# dir_name/file_name.lingua_flag
#
code_source="/**
 * $file_name.$lingua_flag -- 
 *
 * Copyright (c) $current_year, Denis Kovalchuk <deniskk25@gmail.com>
 *
 * This code is licensed under a MIT-style license.
 */

$include_source

int main(int argc, char *argv[]) {

    return 0;
}"

#
# dir_name/Makefile
#
makefile_source="CXX        = $compl
CXXFLAGS   = $compl_flags
SOURCES    = \$(wildcard *.$lingua_flag)
OBJECTS    = \$(patsubst %.$lingua_flag, %.o, \$(SOURCES))
EXECUTABLE = $file_name

all: \$(EXECUTABLE)

\$(EXECUTABLE): \$(OBJECTS)
	\$(CXX)  \$(OBJECTS) -o \$(EXECUTABLE)

%.o: %.$lingua_flag
	\$(CXX) \$(CXXFLAGS) \$< -o \$@

clean:
	@rm -f *~
	@rm -f *.o

.PHONY: clean"

#
# create a workspace
#
count=0
mkdir $dir_name$count 2>/dev/null
while [ "$?" != 0 ]
do
    ((count++))
    mkdir $dir_name$count 2>/dev/null
done
dir_name=$dir_name$count

touch $dir_name/$file_name.$lingua_flag
echo  -e "$code_source" > $dir_name/$file_name.$lingua_flag
touch $dir_name/Makefile
echo  -e "$makefile_source" > $dir_name/Makefile
