#!/bin/bash

for ENTRY in `rsync --recursive --list-only download.kiwix.org::download.kiwix.org/portable/ | \
    grep ".zip" | grep -F -v '_nopic_' | tr -s ' ' | cut -d ' ' -f5 | sort -r` ; do
    RADICAL=`echo $ENTRY | sed 's/_20[0-9][0-9]-[0-9][0-9]\.zip//g'`
    if [[ $LAST != $RADICAL ]] ; then
        echo $ENTRY
        LAST=$RADICAL
    fi
done
