# Punkte

## Overview
This app has a single endpoint that returns users. It's easily accessible by executing the following command:

```shell
curl http://localhost:4000
```

```json
{"timestamp":"2022-05-17T18:12:25.334970Z","users":[{"id":11501,"points":87},{"id":11973,"points":85}]}
```

## Installing

This project uses Elixir 1.14.5, so in order to run it one would have to install it and there are many ways to do that for more details check some options like:

- https://asdf-vm.com/
- https://github.com/taylor/kiex

After installing elixir, one can install the dependencies by running `mix deps.get`

This project requires postgres to run locally, to make the process easier a docker-compose.yml is available in the project root, so the instance can be easily spawn by running `docker-compose up -d db`

After that run `./scripts/setup`, that will automatically create the db, migrate and seed with some values. It might take time to complete this process

Now run `./scripts/test`, if its all green, the application is fully set and can be started by running `./scripts/start`

```
./scripts/start
-> Compiling 5 files (.ex)
   Generated punkte app
   The database for Punkte.Repo has already been created

   11:18:24.763 [info] Migrations already up
   [info] Running PunkteWeb.Endpoint with cowboy 2.10.0 at 127.0.0.1:4000 (http)
   [info] Access PunkteWeb.Endpoint at http://localhost:4000

curl localhost:4000
-> {"timestamp":"2023-05-26T09:19:09.913420Z","users":[{"id":1,"points":74},{"id":2,"points":45}]}
```

## Considerations

Command Query Resposibility Segregation (CQRS) is a design which aims to clearly have distinctions between read and modifying data, I feel that this concept matches the challenge pretty well so I created "Commands" for each action possible, the app only needs the `Punkte.User.Evaluate` and `Punkte.User.Fetch` to implement the scenario proposed.

In regards of the app structure it currently has the following:

```
.
├── punkte
│   ├── application.ex
│   ├── repo.ex
│   ├── user
│   │   ├── evaluate.ex
│   │   ├── fetch.ex
│   │   └── server.ex
│   └── user.ex
├── punkte.ex
├── punkte_web
│   ├── controllers
│   │   ├── error_json.ex
│   │   └── users_controller.ex
│   ├── endpoint.ex
│   ├── gettext.ex
│   ├── router.ex
│   └── telemetry.ex
└── punkte_web.ex

4 directories, 14 files
```

All the important files are either prefixed with `user` or within its respective folder. I did not add the `Punkte.User.Server` call within the `User context` because I think that was not necessary given the current scenario, for me that would just add an extra layer without any major improvement.

The `fill_factor` was set to 70%, this number could be even lower to increase the number of `hot updates` but I did not see as necessary right now.

Every single request goes through the `GenServer` one could wonder what would happen in case the DB start taking some time to respond, I think the `process mailbox` could overflow at some point but I also didnt want to focus on solving this right now.


That's all for now, thanks for reviewing! :)
