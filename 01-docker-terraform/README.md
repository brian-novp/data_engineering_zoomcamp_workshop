# Steps done

1. check used port using `ss -tulpn`.
2. confirmed ports that will be used in docker-compose are not being used.
3. if some ports are being used, check for any running containers. `docker ps` .
4. If you remember where the docker compose file is, go to that folder and `docker compose stop` to stop the container and keep the networks and images or `docker compose down` to stop and remove the containers, networks, and images. run `docker ps` and `ss -tulpn`.
5. Make sure ports we'll use are not listed.
6. Go back to the folder that have docker compose yaml we want to spin up.
7. `docker compose up` and `docker ps` in terminal
8. (install uv globally)
```bash 
   curl -LsSf https://astral.sh/uv/install.sh | sh
```
9. restart shell/terminal, confirm uv installation by running `uv --version` and INSERT IMAGE HERE
10. go to working directory, in this case it is `/pipeline`. 
11. `uv init --python=3.13` so that every script we run using `uv run` will be run in python version 3.13 (different python version from host machine, because `uv run` uses the isolated environment) >> This creates a pyproject.toml file for managing dependencies and a .python-version file.
12. `uv add pandas pyarrow sqlalchemy psycopg2-binary` in terminal (notice there is no `--dev` tag, because it will be used in production/deployment) >> This adds pandas pyarrow sqlalchemy psycopg2-binary to your pyproject.toml and installs them in the virtual environment (.venv folder).
13. `uv add --dev jupyter pgcli` (notice there is a `--dev` tag, because it will be used in development only) >> we use jupyter notebook for exploring the data to understand the data and what to do with them. we also use pgcli to interact with our postgres in terminal.
14. `uv run jupyter notebook` in terminal, copy paste the link to browser to access jupyter notebook
15. Download and explore the data. Link to notebook.
16. After finished exploring the data and drafting what we need to do with the data, dockerize the pipeline using custom docker image by writing in Dockerfile.
17. 

downloading uv 0.9.26 x86_64-unknown-linux-gnu
no checksums to verify
installing to /home/bri/.local/bin
  uv
  uvx
everything's installed!

To add $HOME/.local/bin to your PATH, either restart your shell or run:

    source $HOME/.local/bin/env (sh, bash, zsh)
    source $HOME/.local/bin/env.fish (fish)
