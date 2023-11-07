#!/bin/bash

prep_endpoint=https://localhost:9000/es/_security/oidc/prepare
authentication_endpoint=https://localhost:9000/es/_security/oidc/authenticate

cd "$(dirname "$0")"

# prepare authentication
prep=$(curl -sSfku facilitator:password \
  -H 'Content-Type: application/json' \
  $prep_endpoint \
  -XPOST  -d '
  {
    "realm" : "oidc2"
  }')

tempFile=$(mktemp)

# Open user log in
open `jq -r '.redirect' <<< $prep`

echo "Listening on port 3000 for redirect"
cat return.html | nc -l 3000 >> $tempFile 2>&1

line=$(head -n 1 $tempFile)
if echo "$line" | grep -qE '^GET'; then
  req=$(echo "$line" | cut -d ' ' -f2 )
else
  echo "Couldn't get authentication code"
  rm $tempFile
  exit 1
fi

# authenticate user
auth=$(curl -fsSku facilitator:password \
  -H 'Content-Type: application/json' \
  $authentication_endpoint \
  -XPOST  -d "
  {
    \"redirect_uri\" : \"http://localhost:3000${req}\",
    \"state\" : $(jq '.state' <<< $prep),
    \"nonce\" : $(jq '.nonce' <<< $prep),
    \"realm\" : $(jq '.realm' <<< $prep)
  }")

echo "Logged in as $(jq '.authentication.metadata."oidc(name)"' <<< $auth)"

# test query
curl -sSk \
  -H "Authorization: Bearer $(jq -r '.access_token' <<< $auth)" \
  https://localhost:9000/es

rm $tempFile