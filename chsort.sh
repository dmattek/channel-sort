#!/bin/bash

#####################################################################
# Script  name      : chsort.sh
#
# Author            : Maciej Dobrzynski
#
# Date created      : 20171218
#
# Purpose           : Process files in the specified directory and move them to
#					  folders based on the filename.
#
# Example usage:
#  assume we have a directory ~/test with files: 
#    RhoA2G_LA_1s_01_w26TIRFFRETacceptor_t75.TIF,
#    RhoA2G_LA_1s_01_w16TIRF CFP_t67.TIF
#    etc.
#
# The filenames above contain:
# - experiment name, RhoA2G_LA_1s_01
# - channel name w16TIRF CFP
# - time point, t67
# 
# "./chsort ~/test" puts these files into subfolders based on experiment name 
# and channel name:
#   RhoA2G_LA_1s_01/w26TIRFFRETacceptor/RhoA2G_LA_1s_01_w26TIRFFRETacceptor_t75.TIF
#   RhoA2G_LA_1s_01/w16TIRF-CFP/RhoA2G_LA_1s_01_w16TIRF-CFP_t67.TIF
#  
#  Note, spaces in subfolders and file names are replaced by dashes.
#
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

usage="This script changes extensions of all files recursively in the current folder.

Usage:
$(basename "$0") [-h] [-f char] [-t char] path

where:
	-h | --help	Show this Help text.
	-e | --ext	File extension (default TIF).
	-d | --debug	Test mode. Explicitly prints extracted and padded numbers. Don't use for "
	

# string: extension of image files
FEXT=TIF

# Flag for test mode
TST=0

# read arguments
TEMP=`getopt -o dhe: --long debug,help,ext: -n 'chsort.sh' -- "$@"`
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
# By default FEXT is "TIF". Can be modified with parameter -e at runtime
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

# use find instead of for file in $(...)
#https://stackoverflow.com/a/17892202/1898713

find $1 -type f -name "$FEXTPATTERN" -print0 | while read -d $'\0' currf; do
	currfname=`echo ${currf##*/}`
	currfdir=`echo ${currf%/*}`
	if [[ $currfname =~ $regex ]]; then
		# replace all spaces with "-" from the filename (not entire path!)
		currfnospaces=`echo ${currfname//[[:space:]]/-}`
		
		# Extract the name of 1st sub-directory
		dir1name="${BASH_REMATCH[1]}"
		# replace all spaces with "-"
		dir1name=`echo ${dir1name//[[:space:]]/-}`

		# Extract the name of 2nd sub-directory
		dir2name="${BASH_REMATCH[2]}"
		# replace all spaces with "-"
		dir2name=`echo ${dir2name//[[:space:]]/-}`

		printf "Moving %s\nTo: %s/%s/%s/%s\n\n" $currf $currfdir $dir1name $dir2name $currfnospaces
		if [ $TST -eq 0 ]; then
			mkdir -p $currfdir/$dir1name/$dir2name
			mv $currf $currfdir/$dir1name/$dir2name/$currfnospaces
		fi
	else
		echo "$currfname doesn't match" >&2 
	fi
done


