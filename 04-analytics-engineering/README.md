# dbt-duckdb local development preparation steps

1. pip install dbt-duckdb (to install dbt core and duckdb adapter/plugin)
2. verify `dbt --version` (it displays the dbt core version and installed plugin or adapters along with its version. In this case duckdb plugin)
3. go to the work dir of the project and execute `dbt init <name of the project>`. enter the adapter needed (choose duckdb). if we installed more than 1 adapter. Otherwise, it knows. This initiates the necessary folder structure. It also creates a hidden folder (`.dbt`) inside user system folder and `profiles.yml` in it. `/home/bri` in WSL2. `profiles.yml` tells how dbt works with the adapter, like setting the --dev or --prod environment, how many threads/memory to use, etc. Update by copy paste from [local setup](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/04-analytics-engineering/setup/local_setup.md)
4. Download and ingest data using [python script](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/04-analytics-engineering/setup/local_setup.md#step-4-download-and-ingest-data)
5. run the python script (big data size for wsl2 standard, make sure unused docker images pruned and vhdx compacted using diskpart)
6. add parquet files inside .gitignore so if we push to remote repo, we do not push the big data
7. in terminal, execute `duckdb -ui` to deploy duckdb ui locally, open in browser, copy the path of .duckdb file
8. Under 'Attached databases', click the + sign, paste the copied path under 'Path' (we can do this from the cli). Write ny-taxi under 'Alias'
9. Open new notebook and query the data (prod or dev schema?). If the data displayed correctly, then the local setup is done.
10. Close the duckdb instance to avoid conflicts.
11. Test the connection. go to dbt project (created by dbt init), run `dbt debug` in the terminal to test connection to duckdb. We expect 'All checks passed!'
12. Install dbt power user extension in vscode to make it easier operating dbt locally