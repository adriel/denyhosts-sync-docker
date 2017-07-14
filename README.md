# DenyHosts Sync

Runs an up to date [DenyHosts Sync](https://github.com/janpascal/denyhosts_sync) 2.2.3 sync server for DenyHosts.

By default it'll startup and create a new database with DenyHosts Sync tables and then start the Sync server.

Once it's running you can access the frontend on port 9911 by default, e.g. http://localhost:9911/ 

## Healthcheck

Healthcheck is built into the Dockerfile, meaning when you start it up its state will be "starting" untill its done 3 health checks which is done every 5 minutes, so ~15 minutes after starting the image and there are no errors you'll get a sate of "healthy" (granted there are no errors).

It'll change to "unhealthy" when it can no longer retrieve the site via http://localhost:9911/ 

## Usage

There is a example [docker-compose.yml](https://github.com/adriel/denyhosts-sync-docker/blob/master/docker-compose.yml) file included in the repository to help you get started, fill in the missing parts.

There also is a [db-variables.env](https://github.com/adriel/denyhosts-sync-docker/blob/master/db-variables.env) file where you can enter the database details like; database name, username/password, hostname etc, which is linked to, in both the server and database images.

Put both these files into a directory and run `docker-compose up -d` in that directory and it'll start both images.

## Logs

Incase you need to troubleshoot you can check the logs from both images by running:

`docker-compose logs -f`

