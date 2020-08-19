#!/bin/bash
#
# Author: Peter Gutmann
# Version: 0.1
#
# This script downloads your personal calendar from a nextcloud instance 
# and converts it into a PDF that can be pushed onto a reMarkable tablet.
#
# Packets needed beyond standard board tools are:
#	
#	remind calendar (https://dianne.skoll.ca/projects/remind/
#		also available as packet for most distros)
#	ical2rem script (AUR, e.g., or directly via Dianne's page)
#	ps2pdf from ghostscript package (or is that a standard board tool....?)
#
#	I also use qpdfview to display my calendar before uploading it to the
#	tablet, you might want to either comment this line or replace qpdfview
#	with your own PDF viewing application.
#
#


today='$date +%F' # for we don't want to override calendars and lose dates...

# now let's download the actual calendar from our Nextcloud instance.
# As I use a self-signed certificate, I need to switch off certificate checks,
# depending on your setup, you might be fine without the switch --no-check-certificate.
#
# Rather than defining three variables here, please replace the placeholders in this line
# with your own credentials and the address of your Nextcloud. As I don't use this script
# over the internet, I don't bother with my password being stored in this config file.

wget --no-check-certificate --user=MY_USERNAME --password=MY_PASSWORD https://SUBDOMAIN.DOMAIN.TLD:PORT/nextcloud/remote.php/dav/calendars/MX_USERNAME/personal?export

# As I haven't found a decent script / program that turns my ical into a
# PDF file that makes sense to look at, I have chosen to take a detour
# using the great remind program (which is not a bad decision to have on 
# one's UN*X machine, anyway...

# convert ical events into remind events

ical2rem --no-todos personal\?export  > Calendar.rem

# convert the text so that German Umlauts are presented correctly. Maybe, you do not
# need this line in your language (if that's English, you can safely skip this step),
# maybe you meed another charset, as you cannot break anything badly here, try out.

iconv -f UTF-8 -t ISO-8859-1 Calendar.rem -o CalendarIso.rem

# now for the output of 12 months' worth of remind events onto a Calendar, and
# piping this into the script that converts this calendar into a PostScript file.

remind -m -p12 Calendar.rem | rem2ps -i -c3 > Cal.ps

# finally, converting PS to PDF which our reMarkable understands.
ps2pdf Cal.ps Cal.pdf

# Display the Calendar to check if everything has worked nicely. Once your system
# is up and running, this line can be commented out.

qpdfview Cal.pdf

# I like to have my Calendars timestamped in their name to keep track. 
mv Cal.pdf Cal_$today.pdf 

rm Calendar.rem CalendarIso.rem Cal.ps Cal.pdf
