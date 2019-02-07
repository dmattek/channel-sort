#!/bin/bash

#####################################################################
# Script  name      : fsort.sh
#
# Author            : Maciej Dobrzynski
#
# Date created      : 20190207
#
# Purpose           : Moves files with a specified extension into folders
#                     (must already exist) with the same name as the filename. 
#
# Example usage:
#  assume we have a directory ~/test with directories and files: 
#    dir1
#    dir1.nd
#    dir2
#    dir2.nd
#
# This script is typically executed after chsort.sh that sorts files
# and creates all the necessary sub-folders. 
#
# WARNING: uses GNU getopt
# Standard OSX installation of getopt doesn't support long params
# Install through macports
# sudo port install getopt
#
# Tested on:
# OSX 10.11.6 (Darwin Kernel Version 15.6.0)
# Ubuntu 16.04.2 LTS
# 
#####################################################################

usage="This script looks for files and moves them to corresponding preexisting folders 

Usage:
$(basename "$0") [-h] [-f char] [-t char] path

where:
	-h | --help	Show this Help text.
	-e | --ext	File extension (default nd).
	-d | --debug	Test mode. Explicitly prints extracted and padded numbers. "
	

# string: extension of image files
FEXT=nd

# Flag for test mode
TST=0

# read arguments
TEMP=`getopt -o dhf:t: --long debug,help,from:,to: -n 'fextch.sh' -- "$@"`
eval set -- "$TEMP"

# Extract options and their arguments into variables.
# Tutorial at:
# http://www.bahmanm.com/blogs/command-line-options-how-to-parse-in-bash-using-getopt

while true ; do
    case "$1" in
        -d|--debug) TST=1 ; shift ;;
        -h|--help) echo "$usage"; exit ;;
        -e|--ext)
            case "$2" in
                "") shift 2 ;;
                *) FEXT=$2 ; shift 2 ;;
            esac ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

# Pattern for looping over the files based on FEXT.
# By default FEXT is "nd". Can be modified with parameter -e at runtime
FEXTPATTERN="*.$FEXT"

# Pattern for dissecting folder names from the file name
regex="(.*)_(w.*)_.*.$FEXT"


# Loop through files
# From: http://stackoverflow.com/a/15088473/1898713

# In order to deal with filenames with spaces,
# temporarily set the IFS (internal field seperator) to the newline character
IFS=$'\n'

# use bash pattern matching
# https://stackoverflow.com/a/1892107/1898713

# use "find" instead of "for file in $(...)"
#https://stackoverflow.com/a/17892202/1898713

find $1 -type f -name "$FEXTPATTERN" -print0 | while read -d $'\0' currf; do
        # extract dir name from nd file name
        destdir=`echo ${currf%.*}`

        if [ -d $destdir ]; then
                printf "Moving %s\nTo: %s\n\n" $currf $destdir
                if [ $TST -eq 0 ]; then
                        #mkdir -p $currfdir/$dir1name/$dir2name
                        mv $currf $destdir
                fi
        else
                printf "Wanted to move %s but the directory %s doesn't exist. Run chsort.sh script first!\n" $currf $destdir
        fi
done

