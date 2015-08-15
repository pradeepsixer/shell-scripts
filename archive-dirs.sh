#!/bin/sh
# Archive Directiories Script

# PURPOSE
#	To archive the directories' contents present within a directory. If there are 10 directories 'dir1', 'dir2', .... 'dir10' in a directory 'parentdir', then the contents within those 10 directories will be archived individually under the names 'dir1.zip', 'dir2.zip', .... (The archive extension can be changed)

# OPTIONS
# 	--extension, -e
#		Extension of the archive to be created. The default extension is ".zip"
#	--directory, -d
#		The directory which contains the directories to be archived. By default, this is present directory
#	--include-directory, -i
#		Include the subdirectory i.e. dirN as well into the dirN.zip archive. By default, the subdirectory is not included
#	--output-directory, -o
#		The directory where the archives are to be created. By default, this is the same as the parent directory (specified by -d)
#	--help, -h
#		Print Help Information
#	--usage, -u
#		Print Usage Information

ARCHIVE_EXTENSION="zip"
PARENT_DIR="."
INCLUDE_SUB_DIR=false
OUTPUT_DIR=""

printUsage() {
	echo "[-e|--extension <Archive Extension>] [-d|--directory <Parent Directory>] [-i|--include-directory] [-o|--output-directory <Output Directory>] [-h|--help] [-u|--usage]"
}

printHelp() {
	echo "HELP INFO NEEDS TO BE UPDATED !!!!"
}

processFlags() {
	while [ $# -gt 0 ]; do
		case $1 in
			-e|--extension)
				if [ $# -lt 2 ]; then
					echo "Extension flag is encountered but no extension specified. Aborting"
					exit 1
				fi
				ARCHIVE_EXTENSION=$2
				shift 2
			;;
			-d|--directory)
				if [ $# -lt 2 ]; then
					echo "Directory flag is encountered but no directory specified. Aborting"	
					exit 1
				fi
				PARENT_DIR=$2
				shift 2
			;;
			-i|--include-directory)
				INCLUDE_SUB_DIR=true
				shift
			;;
			-o|--output-directory)
				if [ $# -lt 2 ]; then
					echo "Output directory flag is encountered but no directory specified. Aborting"	
					exit 1
				fi
				OUTPUT_DIR=$2
				shift 2
			;;
			-u|--usage)
				printUsage
				exit 0
			;;
			-h|--help)
				printHelp
				exit 0
			;;
			-|--)
				shift
			;;
			*)
				shift
			;;
		esac
	done
	if [ "$OUTPUT_DIR" = "" ]; then
		echo "Output Directory is not set. Setting it to Parent Directory (${PARENT_DIR})"
		OUTPUT_DIR=${PARENT_DIR}
	fi
}

compressDirectories() {
	ORIGINAL_DIR=`pwd`
	DIR_NAME=''

	PREV_IFS=$IFS
	IFS=$(echo '\n\b')

	#find "$PARENT_DIR" -mindepth 1 -maxdepth 1 -type d -print0 | while read -d $'\0' EACHDIR	- ONLY FOR BASH, SINCE -d IS SUPPORTED ONLY BY IT
	#find "$PARENT_DIR" -mindepth 1 -maxdepth 1 -type d | while read -r EACHDIR - ALTERNATIVE CONSTRUCT
	for EACHDIR in `find "$PARENT_DIR" -mindepth 1 -maxdepth 1 -type d`
	do
		DIR_NAME="${EACHDIR##*/}"
		if [ "$INCLUDE_SUB_DIR" = "true" ]; then
			cd "$EACHDIR/.."
			zip -r "$OUTPUT_DIR/$DIR_NAME.$ARCHIVE_EXTENSION" "$DIR_NAME"/*
		else
			cd "$EACHDIR"
			zip -r "$OUTPUT_DIR/$DIR_NAME.$ARCHIVE_EXTENSION" *
		fi
		cd "$OLDPWD"
	done
	cd "$ORIGINAL_DIR"
	IFS=PREV_IFS
}

processFlags "$@"
compressDirectories
