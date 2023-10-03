# Battleship CLI

## Game rules
- The game board is A1 through J10
- The ship options are as follows:
    - Carrier, 5 grid spaces
    - Battleship, 4 grid spaces
    - Cruiser, 3 grid spaces
    - Submarine, 3 grid spaces
    - Destroyer, 2 grid spaces
- All commands must start with `./battleship`
- Place ships with the `--placeship` flag and the following elements:
    - Ship
        - `Cruiser`
    - Placement direction
        - `right` or `down`
    - Initial placement grid
        - `D10`
    - An example command
        - `./battleship --placeship "Cruiser down D10"`
- Fire at ships with the `--fire` flag and the grid designation
    - `./battleship --fire "C10"`
- The game will provide feedback about ship placement, hits, misses, and any errors

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
1. With the setup complete, in that same tab, play the game as per the instructions in the [Game rules](#game-rules)
