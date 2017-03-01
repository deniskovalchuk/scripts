#!/bin/bash
#######################################################################
# Script for creating a workspace C/C++.                              #
#                                                                     #
# Usage: ./create_c_workspace [OPTION]                                #
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
year=$(date +"%Y")

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

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

case $lingua_flag in
    "c")
        code_source_template=$SCRIPT_DIR/templates/template_c
        makefile_template=$SCRIPT_DIR/templates/Makefile_c
        ;;
    "cpp")
        code_source_template=$SCRIPT_DIR/templates/template_cpp
        makefile_template=$SCRIPT_DIR/templates/Makefile_cpp
        ;;
    *)
        echo "Wrong lingua flag."
        exit 1
        ;;
esac

# dir_name/file_name.lingua_flag
code_source=$(cat $code_source_template | sed "s/file_name/$file_name/g" | sed "s/year/$year/g")

# dir_name/Makefile
makefile_source=$(cat $makefile_template | sed "s/file_name/$file_name/g")

# create a workspace
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
