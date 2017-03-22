#!/bin/bash
#######################################################################
# Script for opening last screen via gimp.                            #
#                                                                     #
# Copyright (c) 2017, Denis Kovalchuk <deniskk25@gmail.com>           #
#                                                                     #  
# This code is licensed under a MIT-style license.                    #  
#######################################################################

screen_path=~/Изображения/
file_name=$(ls -t $screen_path | head -1)

if [[ -n $file_name ]]
then
    gimp "$screen_path$file_name" 2>/dev/null &
else
    echo "File not found."
fi
