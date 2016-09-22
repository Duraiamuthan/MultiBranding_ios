xcodedir=$1

function usage {
# FIXME we cannot parse args properly because 2 are optional...
echo "USAGE: $0 xcodedir"
echo "  xcodedir: an install dir like /Application/Xcode6.1.1.app"
}

if [[ $# -ne 1 ]]; then
echo "ERROR: invalid number of arguments"
usage
exit -1
fi

pi="$xcodedir/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/PackageApplication"
piorig="$piOrig"

if [[ ! -f "$pi" ]]; then
echo "$pi file not found. Invalid argument ?"
usage
exit -1
fi

grep resource-rules "$pi"
if [[ $? -ne 0 ]]; then
echo "PackageApplication doesn't use resource-rules. Skipping"
exit 0
fi

if [[ -f "$piorig" ]]; then
echo "Backup file $piorig already exist. Aborting"
exit -1
fi

perl  -p -i'Orig' -e 'BEGIN{undef $/;} s/,resource-rules(.*sign}).*ResourceRules.plist"/$1/smg' "$pi"
echo $?