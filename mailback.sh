#!/bin/bash
##
## author Peter Gutmann
## version 0.5


#### Packages needed beyond bash
#
# mutt ("All mail clients suck. This one just sucks less."; http://www.mutt.org)
#
####

#### Usage ###
#
# For this script to work, you need PDFs produced by the script
# coronaprint.sh
# 
# Adapt the text of the mail body that is sent with the corrected PDF attached
# by editing the Text in BODY.
# Adapt the subject of the automated mail in SUBJECT.
#
# Edit the place of the mutt-config you want to use
# Start this script in the folder where the corrected PDFs are stored.
# 
# If you prefer to be even quicker and mailx-liker, add "-x" to the mutt line.
# Then, you can simply press "." to send the mail rather than having the
# opportunity to still alter subject and body.


MUTTCONFIG=~/.mutt/YOUR_CONFIG_FILE
for i in *.pdf
do
	a=$(echo $i | cut -d @ -f1)
	b=$(echo $i | cut -d @ -f2)
	c=$a\@$b
	  
	echo "$c"
	mutt $c -F $MUTTCONFIG -s "Korrektur zurück" -i body.msg -a $i 
done
