#!/bin/bash
# security cms -D -i ~/Library/MobileDevice/Provisioning\ Profiles/UPPER_CASE_UDID_HERE.mobileprovision

RULE="GetUUID [-n \"Name\"]"

if [[ $1 != "-n" ]]; then
    echo $RULE
    exit 1
fi

if [[ $2 == "" ]]; then
    echo $RULE
    exit 1
fi

filelist=`ls ~/Library/MobileDevice/Provisioning\ Profiles`
TEMPFILE=/private/tmp/pTemp.plist
NOWDATE=`date +%d`

CREATETIME=0
UUID=""

for file in $filelist
do
    security cms -D -i ~/Library/MobileDevice/Provisioning\ Profiles/${file} > ${TEMPFILE} 2>/dev/null
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
