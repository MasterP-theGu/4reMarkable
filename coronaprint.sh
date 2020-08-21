#!/bin/bash
##
## author Peter Gutmann
## version 1.0


#### Packages needed beyond bash
#
# You might need to install some of these using the appropriate install mechanism of your distribution
#
# ripmime (https://github.com/inflex/ripMIME)
# ImageMagick or GraphicsMagick for convert
# poppler suite of PDF tools for pdfunite
# ghostscript for pdf2ps and ps2pdf
# a2ps (as of ver 1.0 I prefer this to cupsfiltering as it copes better with misformed mail bodies)
# cups for cupsfilter (an alternative to a2ps | ps2pdf)


#### Usage ####
#
# Start this script from within the folder that contains your emails.
# The format of the mails does not matter as long as ripmime can deal with it.
# Safely tested are currently 
#	imap-folders set up by offlineimap 
#
# You might want to adapt the basic variables:

PRINTHOME=~/Coronaprint


#### create the PrintHome directory if it doesn't already exist
#### this is where all the PDFs will be stored. It is also the working directory.


if [ ! -d $PRINTHOME ] 
then
    mkdir -p $PRINTHOME
fi


#### extract the attachments with ripmime, save them in separate directories under PrintHome

for i in *
	do 	mkdir $PRINTHOME/$i
		ripmime -i $i -d $PRINTHOME/$i -e header.txt --syslog
	done

### all further work is done in PrintHome directory
### BaseName 1: the header.txt file contains all the mail's headers. We extract the mailadress that's set as return address. 
### 		alternatively, one could extract the "From" address, but due to different formats and lengths of names, the 
###		return-path is much safer.
### BaseName 2: again from the header.txt we grep the timestamp when the mail was delivered; this is to add a unique part to
###		the filename to avoid confusion with multiple mails from the same sender.
###
### The additional "@" between the two BaseNames is needed for the script "mailback.sh" to work, which re-extracts the
### respective mailaddresses from the filenames and automatically mails the file back to the sender.
###
### for debugging you might want to comment out the line "rm -R $dir"

for dir in $PRINTHOME/*/;
	
	do	cd $dir

		BASENAME1=$(grep -o 'Return-path: <[[:alnum:]+\.\_\-]*@[[:alnum:]+\.\_\-]*' header.txt | cut -c 15-)
		BASENAME2=$(grep "Delivery-date" header.txt | cut -c 21- | cut -c -17 | sed -e 's/ /_/g')
		BASENAME3=$(grep "Subject:" header.txt | cut -c 10-)
		cat textf* > TXT
		a2ps --center-title="$BASENAME3" --footer="Corona PDF" -2 -o body.ps TXT 
		ps2pdf body.ps body.pdf
		## OR:
		#cupsfilter TXT > body.pdf
		convert *.{jpg,jpeg,png,tiff} -colorspace Gray pictures.pdf 2>/dev/null
		unoconv *.{odt,doc,docx,ods,xls,xlsx} 2>/dev/null
		pdfunite *.pdf large.pdf
		# the next two steps reduce the size of the pdf significantly without remarkable loss of quality
		pdf2ps large.pdf tmp.ps
		ps2pdf tmp.ps $BASENAME1\@--$BASENAME2.pdf
		mv $BASENAME1\@--$BASENAME2.pdf $PRINTHOME
		# remove the directory and all its contents as they're no longer needed (the original mail is still there)
		# comment this out if you want to check if the files are generated correctly or if you'd like to do some
		# finetuning to the convert command line.
		rm ./*
	done	
find $PRINTHOME -empty -type d -delete

	exit=0
