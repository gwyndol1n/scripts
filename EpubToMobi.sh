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
epubsToConvert="$(find "$PWD" -type f -name '*.epub' -print)"

# iterate thru newline-separated list of .epubs in directory
while read -r epubFromListToConvert; do
	# set epub to current epub in list
	epub="$epubFromListToConvert"
	#echo $epub

	# set destination filename for conversion, also used to check if .epub
	# has already been converted; ebook-convert overwrites existing file, saves time to skip
	epubToMobi="${epubFromListToConvert%.*}.mobi"
	#echo $epubToMobi

	# while destination file doesn't exist
	while [ ! -f "$epubToMobi" ] ;
	do
		clear
		echo "======================================"
		echo "=======CONVERTING .EPUB TO .MOBI======"
		echo "======================================"
		echo -e "\n\n"
		#clear
		/usr/bin/ebook-convert "$epub" "$epubToMobi"
		#clear
		echo "======================================"
		echo "=========CONVERSION SUCCESSFUL========"
		echo "======================================"
		echo -e "\n\n"
		break
	done
	break
done <<< "$epubsToConvert"
# to use read for list, must end while loop with "<<< $list_name"