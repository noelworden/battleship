# Battleship

## Requirements
- Install [Docker Desktop](https://docs.docker.com/desktop/install/mac-install/)
- Install [asdf](https://asdf-vm.com/guide/getting-started.html)

## Startup steps
1. Clone down the repo and navigate to it in the terminal
1. Install languages via `asdf`
    - `asdf plugin add erlang`
    - `asdf plugin add elixir`
    - `asdf install`
1. In one tab, start the database, as a `postres` instance with `docker`
    ```
    docker container run \
    --name postgres -p 5432:5432 \
    -e POSTGRES_PASSWORD=postgres \
    --rm postgres:15.4-alpine
    ```
1. In a second tab, setup the project
    - `mix setup`
1. In that same tab, play the game    
    1. Place ships 
        - `./battleship --placeship "Cruiser down D10"`
        
    1. Fire at ships
        - `./battleship --fire "C10"`
