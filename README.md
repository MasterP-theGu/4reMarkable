# 4reMarkable
A collection of my scripts for the reMarkable tablet.

There is not yet a lot here to say, currently all necessary information is in the actual script. 

I might add more of my reMarkable-related scripts here, so there's a little README to start with.

*NCcalendar4reMarkable.sh* provides a script to download a personal calendar from a Nextcloud instance and convert it into a PDF that makes sense on a reMarkable tablet.

*Coronaprint4reMarkable.sh* converts emails and their attachments into PDFs that can be pushed onto a reMarkable.
*Mailback4reMarkable.sh* takes PDFs from a reMarkable, extracts email-addresses from the filename and mails them using mutt.

The history behind these two scripts:
I came up with the workflow of these two scripts when I had to correct hundreds of papers and exercises my students sent me from their home work spaces during the corona lockdown (hence the name of the script). Not all students knew how to produce proper PDFs, some only had a cheap mobile phone to take pictures rather than make scans of their handwritten work, etc. So, I ended up receiving hundreds of emails with a plethora of different attachments all containing what needed grading. I downloaded the mails to my harddrive using offlineimap. Then, *Coronaprint4reMarkable.sh* would do all the work. After marking, I pulled the PDFs from my reMarkable and *Mailback4reMarkable.sh* would take care of mailing them back to whoever had handed in that paper.


Currently, I still use the USB web interface either using usb proper or via WiFi as I still haven't found a solution to push PDFs to either the tablet directly or using the cloud API that makes me happy. There are lots of such solutions around and many people have already found theirs. As soon as I feel comfortable with one or the other, I shall include such a direct upload of my reMarkable files here.
rmapi (https://github.com/juruen/rmapi) looks very promising and I introduce it as an option in *NCcalendar4reMarkable.sh* and see how it works. 
