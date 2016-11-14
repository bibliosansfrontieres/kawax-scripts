## kawax

`kawax` is a server used to mirror download.kiwix.org.

`kawax(1)` is the script that manages it. It manages the mirroring of our
fileserver, downloads the latest ZIms from Kiwix.org and the other packages we
included in our [catalogs](https://github.com/ideascube/catalog-i-o).

### Configuration

Various paths and options can be tweaked at the beginning of the script.

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


### Bonus

Errors are features.

`rsync_kiwix` errors tells us which ZIms should be updated in our catalog:

    $ ./kawax rsync_kiwix
    rsync: link_stat "/portable/wikivoyage/kiwix-0.9+wikivoyage_fr_all_2016-03.zip" (in download.kiwix.org) failed: No such file or directory (2)
    rsync: link_stat "/portable/wikipedia/kiwix-0.9+wikipedia_pt_all_2015-10.zip" (in download.kiwix.org) failed: No such file or directory (2)

    rsync error: some files/attrs were not transferred (see previous errors) (code 23) at main.c(1655) [generator=3.1.1]
    Command exited with non-zero status 23

This error from `wget_other` underlines a package that has been
[added to the catalog but was never uploaded](https://github.com/ideascube/catalog-i-o/commit/c523c12869c691b5edea6d1b16857e0c6347b427):

    $ ./kawax wget_other
    [...]

    --2016-11-10 21:34:48--  http://filer.bsf-intranet.org/ideascube-catalog/cinescuela/cinescuela.zip
    Connexion à filer.bsf-intranet.org (filer.bsf-intranet.org)|37.187.151.52|:80… connecté.
    requête HTTP transmise, en attente de la réponse… 200 OK
    Taille : 52508531 (50M) [application/zip]
    Sauvegarde en : « /srv/kawax/other/filer.bsf-intranet.org/ideascube-catalog/cinescuela/cinescuela.zip »

    /srv/kawax/other/filer.bsf-intranet.org/ideascube-catalo 100%[===================================================================================================================================>]  50,08M  36,3MB/s   ds 1,4s
    2016-11-10 21:34:52 (36,3 MB/s) — « /srv/kawax/other/filer.bsf-intranet.org/ideascube-catalog/cinescuela/cinescuela.zip » sauvegardé [52508531/52508531]

    --2016-11-10 21:34:52--  http://filer.bsf-intranet.org/ideascube-catalog/maguare/maguare.zip
    Réutilisation de la connexion existante à filer.bsf-intranet.org:80.
    requête HTTP transmise, en attente de la réponse… 404 Not Found
    2016-11-10 21:34:52 erreur 404 : Not Found.

    Terminé — 2016-11-10 21:34:52 —
    Temps total effectif : 24m 6s
    Téléchargés : 15 fichiers, 12G en 24m 3s (8,31 MB/s)



# vim: set tw=78:
