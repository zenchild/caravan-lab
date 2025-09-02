# CaravanLab

This is a basic Phoenix application that demonstrates automatic clustering with
[Caravan](https://github.com/uberbrodt/caravan). This lab uses Consul for DNS
discovery using SRV records. It could probably be reused with any service mesh
that supports SRV DNS discovery.

## Starting the Lab

The lab uses a [Taskfile](https://taskfile.dev/) to aid in running things. To
ensure you have all of the necessary tools, there is a Brewfile in the root
directory to help with this if you are on OSX.

**Install CLI Tools**

* `brew bundle`

**Run The Lab**

* `task up`

It will take a few minutes to build the Docker images upon initial startup, but
once they are built, the lab should be ready to use.

You can access the Consul UI at http://localhost:8500/. There isn't anything
needed to do in Consul, but it is there for you to explore. This lab uses
[docker-consul-agent](https://github.com/zenchild/docker-consul-agent) to add
new services to Consul using Docker labels in the `docker-compose.yml` file.

## Verify the Cluster

Once the lab is up and running, you can verify that the cluster is working by
running the following command:

* `task iex_a`

This will drop you into an IEx shell on node_a. You can then run the following
command to verify that the cluster is working:

* `Node.list()`

## Clean-up

You can clean up the lab by running the following command:

* `task down`


## Running in Nomad

There is an `app.nomad` jobspec that you can use to run the application in
Nomad. You need to specify the Docker image to use when you run the job and that
might look like this:

```shell
nomad job run \
  -var="docker-image=<your_docker_image>" \
  app.nomad
```
