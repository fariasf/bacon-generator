#!/bin/bash

if [ ! -f ./plugin-stub/plugin.php ]; then
    echo "Plugin stub not found! Put the script next to bacon files or symlink the plugin-stub folder next to this script."
    exit 1
fi

while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -n|--name)
    NAME="$2"
    shift
    ;;
    -d|--description)
    DESCRIPTION="$2"
    shift
    ;;
    *)
    ;;
esac
shift
done

if [ -z "$NAME" ]; then
    echo "Plugin name is mandatory!"
    exit 1
fi

INITIALS=""
for word in $NAME;
do
    INITIALS+=${word:0:1}
done;
LOWERCASE_INITIALS="$( echo ${INITIALS} | tr '[:upper:]' '[:lower:]')"
CLASS_NAME="$(awk '{for(i=0;++i<=NF;){OFS=(i==NF)?RS:FS;printf toupper(substr($i,0,1)) substr($i,2) OFS }}' <<< "$NAME" | tr ' ' '_')"
CLASS_NAME+="_Controller"
TEXT_DOMAIN="$(awk '{for(i=0;++i<=NF;){OFS=(i==NF)?RS:FS;printf toupper(substr($i,0,1)) substr($i,2) OFS }}' <<< "$NAME" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')"
AUTHOR="$(git config user.name)"
AUTHOR_EMAIL="$(git config user.email)"
YEAR="$(date +'%Y')"

sed -e 's/\/\/namespace YOUR_PLUGIN_NAMESPACE;//g' -e "s/YOUR_PLUGIN_NAME/$NAME/g" -e "s/YOUR_PLUGIN_DESCRIPTION/$DESCRIPTION/g" -e "s/Author: Mikel King/Author: $AUTHOR/g" -e "s/YOUR_PLUGIN_TEXT_DOMAIN/$TEXT_DOMAIN/g" -e "s/Copyright (C) 2014, Mikel King, olivent.com, (mikel.king AT olivent DOT com)/Copyright (c) $YEAR, $AUTHOR ($AUTHOR_EMAIL)/g" -e "s/Your_Plugin_Controller/$CLASS_NAME/g" -e "s/\$ypc/\$$LOWERCASE_INITIALS/g" -e "s/\$ps/\$$LOWERCASE_INITIALS/g" -e "s/1.3/1.0/g" plugin-stub/plugin.php
