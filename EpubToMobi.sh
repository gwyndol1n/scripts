#!/bin/bash
# Script to automate ebook-convert of ebooks directory (from epub to mobi)
# requires ebook-convert package from calibre

# check for installation of calibre package for ebook-convert usage
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' calibre|grep "install ok installed")
echo "Checking for calibre installation..."
if [ "" == "$PKG_OK" ]; then
	echo "No calibre installation found. Installing calibre."
	sudo apt-get install calibre
else
	echo "calibre already installed. Continuing with conversion."
	echo -e "\n\n"
fi

echo "======================================"
echo "===========EBOOK CONVERSION==========="
echo "======================================"

# find all epubs in $PWD
# $PWD for path does current working directory of script location
# -print argument puts \n after each result in variable

#mobisConverted="$(find "$PWD" -type f -name '*.mobi' -print)"
#epubsToConvert="$(find "$PWD" -type f -name '*.epub' -print)"
filesToConvert="$(find "$PWD" -type f -regex ".*/.*\.\(docx\|epub\|lit\|pdf\|rtf\|txt\)" -print)"

# iterate thru newline-separated list of .epubs in directory
while read -r fileFromListToConvert; do
	# set file to current file in list
	file="$fileFromListToConvert"
	#echo $file

	# set destination filename for conversion, also used to check if input file
	# has already been converted; ebook-convert overwrites existing file, saves time to skip
	# replacing .mobi in this string will change file type for conversion; see
	# https://manual.calibre-ebook.com/generated/en/ebook-convert.html for options

	fileToMobi="${fileFromListToConvert%.*}.mobi"
	#echo $fileToMobi

	# while destination file doesn't exist
	while [ ! -f "$fileToMobi" ] ;
	do
		clear
		echo "======================================"
		echo "=======CONVERTING FILE TO .MOBI======="
		echo "======================================"
		echo -e "\n\n"
		#clear
		/usr/bin/ebook-convert "$file" "$fileToMobi"
		#clear
		echo "======================================"
		echo "=========CONVERSION SUCCESSFUL========"
		echo "======================================"
		echo -e "\n\n"
		break
	done
done <<< "$filesToConvert"
# to use read for list, must end while loop with "<<< $list_name"