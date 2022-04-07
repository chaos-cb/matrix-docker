#!/bin/sh
set -euo pipefail
IFS=$'\n\t'

# change these!!
server_domain="https://example.tld"
mreg_location="http://localhost:5000"
admin_api_shared_secret="foobar"

if ! command -v jq &> /dev/null
then
  echo "jq needs to be installed"
  exit
fi

timeOutput=7
echo "Expire in \"$timeOutput\" days or enter a new value: "
read timeInput
if [ -n "$timeInput" ]
then
  timeOutput=$timeInput
fi
exdate=$( date -d "+${timeOutput} days" +%Y-%m-%d)
response=$( curl -s -X POST \
  -H "Authorization: SharedSecret ${admin_api_shared_secret}" \
  -H "Content-Type: application/json" \
  -d '{"max_usage": 1, "expiration_date": "'"$exdate"'"}' \
  ${mreg_location}/api/token )
tokenwords=$( echo $response | jq -r '.name' )
msgdate=$( date -d "${timeOutput} days" +%b" "%d )

echo "Register account before ""$msgdate"" with this link:"
echo "${server_domain}/register?token=""${tokenwords}"
echo "Then download Element Secure Messenger on Apple:"
echo "https://itunes.apple.com/us/app/element/id1083446067?mt=8"
echo "Or Android:"
echo "https://play.google.com/store/apps/details?id=im.vector.app"
