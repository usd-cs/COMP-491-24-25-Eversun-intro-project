# Chitchat App

## Credits

John Phillips, Nikhil Niranjan, Kimil Thomas, Kobe Deutscher

## What is this

Chitchat is a simple social app allowing text posts and comments from different users targeting iOS and Android.

## How to Use

### Server Side

To run the server, clone this repository and navigate to chitchat\_server. Once in the directory run `docker compose up` to spin up the necessary server resources. By default, the API the app reaches out to is exposed on port 8080, however this can be configured in the `docker-compose.yaml` file. Any changes need to be reflected in `chitchat_app/lib/paths.dart` prior to building the apps.

### Client Side

TODO

