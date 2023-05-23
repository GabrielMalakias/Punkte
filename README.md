# Punkte

## Overview
This app has a single endpoint that returns users. It's easily accessible by executing the following command:

# GET /
curl http://localhost:4000

```json
{"timestamp":"2022-05-17T18:12:25.334970Z","users":[{"id":11501,"points":87},{"id":11973,"points":85}]}
```

## Installing

This project uses Elixir 1.14.5, so in order to run it one would have to install it and there are many ways to do that for more details check some options like:

- https://asdf-vm.com/
- https://github.com/taylor/kiex

After installing elixir, one can install the dependencies by running `mix deps.get`

This project requires postgres to run locally, to make the process easier a docker-compose.yml is available in the project root, so the instance can be easily spawn by running `docker-compose up -d db`

After that run ./scripts/setup, that will automatically create the db, migrate and seed with some values. It might take time to complete this process

Now run ./scripts/test if its all green the application is fully set and can be started by running ./scripts/start

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
