# ChitChat

## Requirements

This project requires docker compose to run the server locally. In order to install docker and docker compose, please visit the [Docker engine install page](https://docs.docker.com/engine/install/) and follow the instructions for your OS.

To confirm docker compose is working you should be able to run the following command withut errors

```bash
docker compose version
```

### Running the program

To deploy the database please change your passwords in the docker-compose.yml file. After changing your passwords run the following command:

```bash
docker compose up
```

### Stopping the program

To stop the program, if you have access to the original terminal you launched it from you can just hit `ctrl+c`. If you lost, closed or no longer have access to the terminal you ran the launch command from, please navigate to your the repository directory and type the following command.

```bash
docker compose down
```

#### Removing volumes

If you would like to completely remove the volumes associated with the databases for a fresh start, please follow the following steps.

- When stopping the app run `docker compose down -v.` Then run
```
rm -rf ./sql/dbdata ./sql/pgadmin-data/
```
- Run `docker volume ls` to confirm there are no volumes remaining for this application.