# Preparation steps
1. open wsl2 terminal, `ss -tulpn` to check ports . Make sure ports we use in docker compose are not being used by other services.
2. if some ports are being use, check whether any docker container running `docker ps`. Kill the container, using `docker stop` or go to the directory that has the docker-compose file corresponds to the containers and `docker compose down`
3. go to working dir that has docker-compose.yaml file
4. `docker compose up` the `02/workflow/ochestration/docker-compose.yaml` (no `-d` because we want to read the log)
5. open browser, go to localhost:8080 (this is the port that kestra use), login using credentials defined inside docker-compose.yaml


# Data Pipeline local (Postgres)
1. Open browser, go to localhost:8085 (pgadmin port defined in docker-compose.yaml), login using credentials defined inside docker-compose.yaml
2. Add new server, name the server, click Connection tab
3. Populate using values defined inside docker compose file.
   Host name/address : (insert service name)
   Port : (insert port defined)
   Maintenance database: (insert POSTGRES_DB env variable)
   Username: (insert POSTGRES_USER env variable)
   Password: (insert POSTGRES_PASSWORD env variable)
4. click Save, refresh page
5. In the tree menu on the left side of the screen, click servers, click the server name > database > 
