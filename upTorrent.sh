#!/bin/bash

# UpTorrent - Author Jorge Davison (a.k.a harley) jdavisonc at gmail dot com
# =========
# Automatic uploader for torrent files with Seedboxer API.

ICON=/usr/share/icons/bittorrent.png
GROWL_NOTIF=/usr/local/bin/growlnotify
LIBNOTIFY_NOTIF=notify-send
CURL=/usr/bin/curl

source ~/.config/upTorrent.conf

usage()
{
cat << EOF
USAGE: $0 -f TORRENT_FILE

UpTorrent Automatic uploader for torrent files to FTP server.

OPTIONS:
   -h      Show this message
   -f      File to upload

EOF
}

# get options
while getopts "hf:" OPTION
   do
      case $OPTION in
         h)
            usage
            exit 1
            ;;
         f)
            TO_UPLOAD=$OPTARG
            ;;

         ?)
            usage
            exit
            ;;
      esac
done

# check parameters
if [[ -z $SEEDBOXER_SERVER ]] || [[ -z $USERNAME ]] || [[ -z $TO_UPLOAD ]]; then
   usage
   exit 1
fi

# check extension to be 'torrent'
if [[ "${TO_UPLOAD/*./}" != "torrent" ]]; then
   echo "Incorrect file to upload, only .torrent files."
   exit 1
fi

# declare command
CMD="$CURL -v -F file=@$TO_UPLOAD -F username=$USERNAME $SEEDBOXER_SERVER/webservices/torrents/add?apikey=$APIKEY"

# execute command
OUTPUT=`$CMD`
EXIT_STATUS=$(echo $?)
MSG_NOTIF="Upload `basename $TO_UPLOAD` Completed!"
if [[ $EXIT_STATUS -ge 2 ]]; then
   # wrong
   MSG_NOTIF="Upload Failed!!"
fi

if [[ "$NOTIF_SYSTEM" == "libnotify" ]]; then
   $LIBNOTIFY_NOTIF --icon=$ICON "upTorrent" "$MSG_NOTIF"
elif [[ "$NOTIF_SYSTEM" == "growl" ]]; then
   $GROWL_NOTIF --image=$ICON -n "upTorrent" -m "$MSG_NOTIF"
fi

