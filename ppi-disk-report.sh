#!/bin/sh

PPIPATH='/srv/others/preprod_images'
REPORTFILE="${PPIPATH}/DISKREPORT.txt"

cd $PPIPATH || exit 1
rm -f $REPORTFILE


header='######################################################################'

{

  echo "Rapport du $(date +%Y/%m/%d ) a $( date +%H:%M:%S )"
  echo

  echo $header
  echo "Projets en Approve prets a etre Deploy :"
  echo

  echo "
taille projet type process_id
------ ------------------ --------- --------------------------------
$( du -sch -- */*/* | tr '/' ' ' )" \
    | column -t

  echo
  echo $header
  echo "Utilisation du disque dur :"
  echo

  df --human-readable $PPIPATH --output=target,size,used,avail,pcent | sed -e 's/é/e/g'

} >> $REPORTFILE

{
    echo
    echo $header
    echo "Approve en cours de copie sur les CAP :"
    echo

    smbstatus | sed -n -e '/^Service/,$p' >> $REPORTFILE
} >> $REPORTFILE



chmod a+r $REPORTFILE
