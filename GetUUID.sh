#!/bin/bash
# security cms -D -i ~/Library/MobileDevice/Provisioning\ Profiles/UPPER_CASE_UDID_HERE.mobileprovision

# echo $1
# echo $2
filelist=`ls ~/Library/MobileDevice/Provisioning\ Profiles`
TEMPFILE=/private/tmp/pTemp.plist
NOWDATE=`date +%d`

CREATETIME=0
UUID=0

for file in $filelist
do
    security cms -D -i ~/Library/MobileDevice/Provisioning\ Profiles/${file} >> ${TEMPFILE}
    Name=`/usr/libexec/PlistBuddy -c "print Name" ${TEMPFILE}`

    if [ "$Name" = "$2" ]; then
        CreationDate=`/usr/libexec/PlistBuddy -c "print CreationDate" ${TEMPFILE}`
        timestamp1=`date -j -f "%a %b %d %T %Z %Y" "${CreationDate}" +"%s"`
        if [ $timestamp1 -gt $CREATETIME ]; then
            ExpirationDate=`/usr/libexec/PlistBuddy -c "print ExpirationDate" ${TEMPFILE}`
            timestamp2=`date -j -f "%a %b %d %T %Z %Y" "$ExpirationDate" +"%s"`
            if [ $timestamp2 -gt $NOWDATE ]; then
                CREATETIME=$timestamp1
                UUID=`/usr/libexec/PlistBuddy -c "print UUID" ${TEMPFILE}`
            fi
        fi
    fi
    rm ${TEMPFILE}
done

echo $UUID
