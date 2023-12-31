#!/bin/bash

authentication_endpoint=http://localhost:8080/realms/test/protocol/openid-connect/auth
token_endpoint=http://localhost:8080/realms/test/protocol/openid-connect/token
userinfo_endpoint=http://localhost:8080/realms/test/protocol/openid-connect/userinfo
redirectURI=http://localhost:3000
clientID=test
clientSecret=NxLbxxYdOutcvNVZdAtBuEM3kHgZenS2

tempFile=$(mktemp)

# Open user log in
open "${authentication_endpoint}?client_id=${clientID}&redirect_uri=${redirectURI}&response_type=code&scope=openid"

echo "Listening on port 3000 for redirect"
cat return.html | nc -l 3000 >> $tempFile 2>&1

line=$(head -n 1 $tempFile)
if echo "$line" | grep -qE '^GET'; then
  req=$(echo "$line" | cut -d ' ' -f2 )
  code=$(sed -r 's/(.*)code=([a-z.0-9-]*)($|&.*)/\2/g' <<< $req)
else
  echo "Couldn't get authentication code"
  rm $tempFile
  exit 1
fi

# Get access token
access_token=$(curl -fsS \
  --data-urlencode "code=${code}" \
  --data-urlencode "client_id=${clientID}" \
  --data-urlencode "client_secret=${clientSecret}" \
  --data-urlencode "redirect_uri=${redirectURI}" \
  --data-urlencode "grant_type=authorization_code" \
  "${token_endpoint}" |
  jq -r '.access_token')

decoded_access_token=$(echo "$(cut -d '.' -f2 <<< ${access_token})==" | base64 -d)

echo "Hello $(jq -r '.preferred_username' <<< $decoded_access_token ), you're email is: $(jq -r '.email' <<< $decoded_access_token )"

# Get user info
curl  -fsS \
  -H "Authorization: Bearer ${access_token}" \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  "${userinfo_endpoint}" | jq

rm $tempFile