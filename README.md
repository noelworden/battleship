# Battleship

## Requirements
- [Docker Desktop](https://docs.docker.com/desktop/install/mac-install/)
- [asdf](https://asdf-vm.com/)

## Startup steps
1. install languages via `asdf`
    - `asdf plugin add erlang`
    - `asdf plugin add elixir`
    - `asdf install`
1. To get your database, start a `postres` instance with `docker`
    ```
    docker container run \
    --name postgres -p 5432:5432 \
    -e POSTGRES_PASSWORD=postgres \
    --rm postgres:15.4-alpine
    ```
1. Spin up project
    - `mix setup`
1. Place ships 
    -  `./battleship --placeship "Cruiser down D10"`
1. Fire at ships
    - `./battleship --fire "C10"`


