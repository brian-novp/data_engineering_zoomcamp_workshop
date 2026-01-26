# Steps done

1. check used port using `ss -tulpn`.
2. confirmed ports that will be used in docker-compose are not being used.
3. if some ports are being used, check for any running containers. `docker ps` .
4. If you remember where the docker compose file is, go to that folder and `docker compose stop` to stop the container and keep the networks and images or `docker compose down` to stop and remove the containers, networks, and images. run `docker ps` and `ss -tulpn`.
5. Make sure ports we'll use are not listed.
6. Go back to the folder that have docker compose yaml we want to spin up.
7. `docker compose up` and `docker ps` in terminal
8. `pip install uv`
9.  `uv add pandas sqlalchemy psycopg2-binary` in terminal (notice there is no `--dev` tag, because it will be used in production/deployment)
10. `uv add --dev jupyter pgcli` (notice there is `--dev` tag, because it will be used in development only)