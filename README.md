## kawax

`kawax` is a server used to mirror download.kiwix.org.

`kawax(1)` is the script that manages it. It manages the mirroring of our
fileserver, downloads the latest ZIms from Kiwix.org and the other packages we
included in our [catalogs](https://github.com/ideascube/catalog-i-o).


### Usage

    $ ./kawax help
    Usage: kawax <action>

    Actions:

        update_catalogs     Update the catalogs cache
        extract_urls        Extracts the URLs from catalogs to files
        rsync_kiwix         Downloads ZIMs from Kiwix
        wget_other          Downloads the other packages
        rsync_synology      Updates the Synology cache
        all                 All of the above
        help                This very help message



# vim: set tw=78:
