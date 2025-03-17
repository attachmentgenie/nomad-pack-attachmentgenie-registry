# Attachmentgenie Nomad Pack Registry

This repository will hold a curated set of [Nomad Packs](https://github.com/hashicorp/nomad-pack) related to all things observability.

See the [documentation on Writing Packs and Registries](https://github.com/hashicorp/nomad-pack/blob/main/docs/writing-packs.md) for more information.

This registry current holds packs for the following tools

* [Atc](./packs/atc/README.md)
* [Atlantis](./packs/atlantis/README.md)
* [Clickhouse UI](./packs/clickhouse-ui/README.md)
* [Clickhouse](./packs/clickhouse/README.md)
* [Docker Registry](./packs/docker-registry/README.md)
* [Docker Registry UI](./packs/docker-registry-ui/README.md)
* [Example](./packs/example/README.md)
* [Heimdall](./packs/heimdall/README.md)
* [Helper Pack](./packs/attachmentgenie_pack_helpers/README.md)
* [Jenkins](./packs/jenkins/README.md)  (fork from community registry)
* [Mailpit](./packs/mailpit/README.md)
* [Minio](./packs/minio/README.md)
* [MySQL](./packs/mysql/README.md)
* [Nomad Autoscaler](./packs/nomad_autoscaler/README.md)  (fork from community registry)
* [Nomad Events Sink](./packs/nomad_events_sink/README.md)
* [Nomad Logger](./packs/nomad_logger/README.md)
* [Opensearch](./packs/opensearch/README.md)
* [Postgresql](./packs/pgsql/README.md)
* [Redis](./packs/redis/README.md)  (fork from community registry)
* [Seaweedfs CSI Driver](./packs/seaweedfs_csi/README.md)

## Deploy packs from this nomad-pack registry

Add your custom repository using the `nomad-pack registry add` command.

```
nomad-pack registry add attachmentgenie github.com/attachmentgenie/nomad-pack-attachmentgenie-registry
```

Deploy your custom packs.

```
nomad-pack run jenkins --registry=attachmentgenie
```

Congrats! You can now write custom packs for Nomad!