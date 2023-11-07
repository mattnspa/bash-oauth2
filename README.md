# Simple OAuth2 bash login


# login.sh
Logs into an OAuth2 provider using athentication flow and retrieves user info.

_Assumption_: An auth service is running, for example [keycloak](./docker-compose.yaml).
- Update endpoints and relevant config in [login.sh](./login.sh)
- run using `./login.sh`

# elastic-login.sh
Logs into an OAuth2 provider using elastic as an OpenID Connect Provider and makes and example request.

_Assumption_: An auth service is running, for example [keycloak](./backend/docker-compose.yaml) and elastic, see [run.md](./backend/run.md) on how to setup.
- Update endpoints and relevant config in [login-elastic.sh](./login-elastic.sh)
- When authenticating, elastic returns a json similar to [elastic-auth-return.json](./elastic-auth-return.json)
