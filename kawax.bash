#!/bin/bash

#
# configuration
#

DEBUGMODE=1

CATALOGS_CACHE=/var/kawax/catalogs

CATALOGS=(
    http://catalog.ideascube.org/kiwix.yml
    http://catalog.ideascube.org/static-sites.yml
    http://catalog.yohanboniface.me/catalog.yml
)

URLS_KIWIX=/var/kawax/kiwix.rsync
URLS_OTHER=/var/kawax/others.wget

PACKAGE_CACHE=/srv/kawax

WGET_USERAGENT="Mirroring/catalog.ideascube.org"
WGET_OPTIONS="--continue --timestamping --recursive --mirror --user-agent='$WGET_USERAGENT'"


#
# functions
#

show_usage() {
    echo "Usage: $( basename $0 ) <action>

Actions:

    update_catalogs     Update the catalogs cache
    extract_urls        Extracts the URLs from catalogs to files
    rsync_kiwix         Downloads ZIMs from Kiwix
    wget_other          Downloads the other packages
    all                 All of the above
    help                This very help message
"
}

edebug() {
    [[ $DEBUGMODE -eq 1 ]] && echo "[+] $@" >&2
}

get_latest_zims_from_kiwix() {
    for ENTRY in `rsync --recursive --list-only download.kiwix.org::download.kiwix.org/portable/ | \
        grep ".zip" | grep -F -v '_nopic_' | tr -s ' ' | cut -d ' ' -f5 | sort -r` ; do
        RADICAL=`echo $ENTRY | sed 's/_20[0-9][0-9]-[0-9][0-9]\.zim//g'`
        if [[ $LAST != $RADICAL ]] ; then
            echo $ENTRY
            LAST=$RADICAL
        fi
    done
}

urls_from_catalog() {
    local CATALOG=$1
    awk -F'"' ' /url:/ { print $2 }' $CATALOG
}

radical_urls_from_catalog() {
    local CATALOG=$1
    urls_from_catalog $CATALOG | sed 's/_20[0-9][0-9]-[0-9][0-9]\.zip//'
}

update_catalogs() {
    for i in ${CATALOGS[@]} ; do
        edebug $i
        wget $i -q -x -P ${CATALOGS_CACHE}/
    done
}

rsync_kiwix() {
    # FIXME: make it silent, log somewhere.
    rsync -vzrlptD --delete --files-from=$URL_KIWIX \
        download.kiwix.org::download.kiwix.org/portable/ ${PACKAGE_CACHE}/download.kiwix.org/
}

wget_other() {
    # FIXME: this is a placeholder. It will download the entire internet into your fridge.
    wget --input-file=$URLS_OTHER $WGET_OPTIONS -P ${PACKAGE_CACHE}/other/
}

extract_urls() {
    rm -f URLS_KIWIX $URLS_OTHER
    for thiscatalog in $( find $CATALOGS_CACHE -type f -name '*.yml' ) ; do
        edebug "Getting URLs from ${thiscatalog}..."
        while read thisline ; do
            thisurl=$( echo $thisline | awk ' /url:/ { print $2 }' | tr -d '"' )
            if [[ "$thisurl" =~ "http://download.kiwix.org" ]] ; then
                edebug "thisurl->kiwix-> $thisurl"
                echo $thisurl >> $URLS_KIWIX
            elif [ -n "$thisurl" ] ; then
                edebug "thisurl->others-> $thisurl"
                echo $thisurl >> $URLS_OTHER
            fi
        done < $thiscatalog

    done
}



# init
mkdir -p $CATALOGS_CACHE


case "$1" in
    update_catalogs|extract_urls|rsync_kiwix|wget_other)
        $1
        ;;
    all)
        update_catalogs
        extract_urls
        rsync_kiwix
        wget_other
        ;;
    help)
        show_usage
        ;;
    *)
        echo "Error: unknown action: $1" >&2
        show_usage
        exit 1
        ;;
esac

