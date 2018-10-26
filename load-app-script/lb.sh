#/bin/bash!
set -e
DATE=$(date +%s)
while true; do curl -I -X$METHOD "$URL?$DATE" -A "$USERAGENT" ; done
