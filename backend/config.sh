curl -ku elastic:password \
  https://localhost:9000/es/_security/role_mapping/oidc1 \
  -H 'Content-Type: application/json' \
  -XPOST  -d '{"enabled":true,"roles":["superuser"],"rules":{"all":[{"field":{"realm.name":"*"}}]},"metadata":{}}'

curl -ku elastic:password \
  https://localhost:9000/es/_security/role/facilitator-role \
  -H 'Content-Type: application/json' \
  -XPOST  -d '{"cluster":["manage_oidc","manage_token"]}'


curl -ku elastic:password \
  https://localhost:9000/es/_security/user/facilitator \
  -H 'Content-Type: application/json' \
  -XPOST  -d '{"password":"password","roles":["facilitator-role"]}'
