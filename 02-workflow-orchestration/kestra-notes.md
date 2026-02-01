# Preparation steps
1. open wsl2 terminal, `ss -tulpn` to check ports . Make sure ports we use in docker compose are not being used by other services.
2. if some ports are being use, check whether any docker container running `docker ps`. Kill the container, using `docker stop` or go to the directory that has the docker-compose file corresponds to the containers and `docker compose down`
3. go to working dir that has docker-compose.yaml file
4. `docker compose up` the `02/workflow/ochestration/docker-compose.yaml` (no `-d` because we want to read the log)
5. open browser, go to localhost:8080 (this is the port that kestra use), login using credentials defined inside docker-compose.yaml


# Data Pipeline local (Postgres)
1. Open browser, go to localhost:8085 (pgadmin port defined in docker-compose.yaml), login using credentials defined inside docker-compose.yaml
2. Add new server, name the server, click Connection tab
3. Populate using values defined inside docker compose file:
   Host name/address : (insert service name that we define in docker compose yaml)
   Port : (insert port defined in docker compose yaml)
   Maintenance database: (insert POSTGRES_DB env variable that we define in docker compose yaml)
   Username: (insert POSTGRES_USER env variable that we define in docker compose yaml)
   Password: (insert POSTGRES_PASSWORD env variable that we define in docker compose yaml)
4. click Save, refresh page
5. In the tree menu on the left side of the screen, click servers, click the server name > database > ny_taxi > schemas > public > tables (there wont be any tables yet)
6. open kestra, klik Flows, create new flow , copy paste 01-postgres-taxi-scheduled.yaml from repo to Flow, click Save
7. Click Triggers, Click Backfill Execution based on green taxi or yellow taxi
8. Select the desired start and end date for ingestion (remember the intricacies of cron expression, if the end date selected has not pass the cron expression, the data for that date wont be ingested)
9. click Backfill Execution, click Execution on the left side of the menu , click the execution that has RUNNING tag
10. Monitor the Logs or Gantt chart

# Data Pipeline cloud (BigQuery and Google Cloud Storage)
1. Make sure billing account already setup so we can use DDL and DML in BigQuery and use Google Cloud Storage
2. Go to Console, create new project, save the project ID because we need to store it in key value store in Kestra
3. Click BigQuery menu or enter BigQuery in the search bar above
4. Click Navigation menu (burger menu), hover to IAM, click service accounts
5. Create Service Account. Populate fields shown. Click Create and Continue
6. Under Permission, add BigQuery admin and Storage admin, click Continue
7. Under service account admins role, fill in with your email that you use, click done
8. Go back to service account menu, click the newly created service account, click KEYS tab
9. Click add keys, create new key, choose JSON, click create, save the json into your desired folder
10. Open the saved json with your preffered text editor, copy all of the value
11. Open kestra, click KV STORE at the left side of the UI, click New Key Value (Purple box top right)
12. Populate the fields shown
    - Namespace : (the same namespace that we use inside the flow yaml file, so this key value can be accessed by the flows in the same namespace)
    - Key : (this is the key value variable that will be used in the flow, we name if GCP_CREDS)
    - Type : STRING
    - Value : (copy paste the value from the key service account json here)
    - Description : (fill the description so we do not forget)
    - Expiration : set the expiration period if you need it
13. Create new flow, copy paste 02-gcp-kv.yaml, populate the value of each task id, click save and execute
14. Create new flow, copy paste 03-gcp-setup.yaml, populate the value of each task id, click save and execute
15. Create new flow, copy paste 04-gcp-scheduled-bq-etl.yaml, save and click Trigger menu, Backfill Execution based on the date desired. This yaml created an etl pipeline (direct upload from csv downloaded to bigquery without using google cloud storage)
16. Create new flow, copy paste 05-gcp-elt-scheduled.yaml, save and click Trigger menu, Backfill Execution based on the date desired. This yaml is an ELT pipeline (using google cloud storage to store raw csvs and ingest them to BigQuery)
17. Query the data to answer homework

