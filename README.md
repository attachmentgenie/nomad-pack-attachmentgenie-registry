# Attachmentgenie Nomad Pack Registry

This repository will hold a curated set of [Nomad Packs](https://github.com/hashicorp/nomad-pack) related to all things observability.

See the [documentation on Writing Packs and Registries](https://github.com/hashicorp/nomad-pack/blob/main/docs/writing-packs.md) for more information.

This registry current holds packs for the following tools

* Atc
* Clickhouse
* Example
* Heimdall
* Jenkins  (fork from community registry)
* Mailpit
* Minio
* MySQL
* Nomad Autoscaler  (fork from community registry)
* Nomad Events Sink
* Nomad Logger
* Opensearch
* Postgresql
* Redis  (fork from community registry)
* Docker Registry
* Seaweedfs CSI Driver

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