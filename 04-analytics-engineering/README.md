# dbt-duckdb local development preparation steps

1. `python3 -m venv .venv` , activate venv
2. pip install dbt-duckdb (to install dbt core and duckdb adapter/plugin)
3. verify `dbt --version` (it displays the dbt core version and installed plugin or adapters along with its version. In this case duckdb plugin)
4. go to the work dir of the project and execute `dbt init <name of the project>`. enter the adapter needed (choose duckdb). if we installed more than 1 adapter. Otherwise, it knows. This initiates the necessary folder structure. It also creates a hidden folder (`.dbt`) inside user system folder and `profiles.yml` in it. `/home/bri` in WSL2. `profiles.yml` tells how dbt works with the adapter, like setting the --dev or --prod environment, how many threads/memory to use, etc. 
5. `code ~/.dbt/profiles.yml` to open yml file in vscode without clicking the file.
6. Inspect available core or threads allocated in WSL2 by executing `lscpu` or `nproc`. Write down the spec.
7. Update profiles.yml by copy paste from [local setup](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/04-analytics-engineering/setup/local_setup.md) , change memory limit to 4GB and threads to 4, for dev and prod
8. cd to your newly created dbt project folder
9. Download and ingest data using [python script](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/04-analytics-engineering/setup/local_setup.md#step-4-download-and-ingest-data) (just copy paste them)
10. run the python script using virtual environment python interpreter (big data size for wsl2 standard, make sure unused docker images pruned and vhdx compacted using diskpart)
11. add parquet and duckdb files inside .gitignore so if we push to remote repo, we do not push the big data
12. open new terminal (no venv activated)
13. Install duckdb in terminal `curl https://install.duckdb.org | sh` so wsl2 can initialize duckdb cli.
14. go back to virtual env terminal, execute `duckdb -ui` to deploy duckdb ui locally, open in browser, copy the path of .duckdb file
15. Under 'Attached databases', click the + sign, paste the copied path under 'Path' (we can do this from the cli). Write ny-taxi under 'Alias'
16. Open new notebook and query the data (prod schema will be shown instead of dev because python script defined it as prod). If the data displayed correctly, then the local setup is done.
17. Close the duckdb instance to avoid conflicts by keyboard interrupt ctrl+D
18. Test the connection. go to dbt project (created by dbt init), run `dbt debug` in the terminal to test connection to duckdb. We expect 'All checks passed!'
19. Install dbt power user extension in vscode to make it easier operating dbt locally
20. Change python interpreter to the venv by copying the python path from `dbt debug` , not doing this will result in dbt power user extension asking to instal dbt core


# dbt project preparation
1. Create `staging` folder inside `models` , create `sources.yml` . Staging and sources.yml are dbt convention. 
2. Create an sql file for each taxies (use file naming convention such as `stg_green_tripdata.sql` instead of just `green_tripdata.sql` to show that this sql file is used in staging)
3. Create a `marts` folder, inside it create `reporting` folder
4. In marts folder, create `dim_vendors.sql`, `dim_locations.sql`, `fct_trips.sql` . As the name convention suggest, there files are for dimension and fact tables.
5. In `reporting` folder, create `monthly_revenue_per_locations.sql`
6. Create an `intermediate` folder under `models` folder, this is where we union all taxies data into a single table
7. Fix the `stg_yellow_tripdata.sql` , ehail fee and trip type column.
8. In terminal, go to the root dbpt project folder and `dbt run`, we expect Completed Successully message.