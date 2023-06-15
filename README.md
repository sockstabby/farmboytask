# Introduction

Farmboy is a distributed and scalable task runner. This is originally intended to be used to collect thousands of datapoints
from an external API.

The project is split up into three repos.

Farmboy - is an Elixir OTP Genserver that is reponsible for discovering workers in a cluster. It uses the Quantum Elixir module to schedule tasks. It distibutes the work by choosing a node with the least load averate. It invokes Farmboy Task passing it
the configuration whenever it is scheduled to run.

Farmboy Task - is the task that you define. This repo provides a sample implementation. Tasks can publish status messages which in turn get written to a Phoenix channel so end users can see the logs in realtime.

Farmboy Web - A user interface, webserver and API to configure tasks and get task status.

Take a look at the in app screenshots in the Web app repo's appscreens folder.

# Building

You have several options to build this code

1. Run a debug build locally

```
iex --name worker@127.0.0.1 --cookie asdf -S  mix
```

2. Build a docker image and run in docker or kubernetes

   ```
   docker build . -t workerimage
   docker tag workerimage {docker-hub-username}/{default-repo-folder-name}:workerimage
   docker push {docker-hub-username}/{default-repo-folder-name}:workerimage

   ```

   Now it will be availabe to create containers in your Kubernetes
   cluster. See the worker_dep.yaml file in Kubs repo for reference.
