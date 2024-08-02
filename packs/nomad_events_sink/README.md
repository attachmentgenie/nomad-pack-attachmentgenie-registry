# nomad_events_sink

An events collection agent which processes Nomad Events and dumps to external sink providers like HTTP

## Pack Usage

  nomad-pack run nomad_events_sink --registry=seaplane -f examples/nomad_events_sink.hcl

## Variables

- `job_name` (string) - The name to use as the job name which overrides using the pack name
- `region` (string "global") - The region where the job should be placed.
- `datacenters` (list(string) ["*"]) - A list of datacenters in the region which are eligible for
  task placement.
- `namespace` (string "default") - The namespace where the job should be placed.
- `priority` (number ["50"]) - The job priority
- `constraints` (list(object)) - Constraints to apply to the entire job.
- `task_config` (object) - Options for the nomad-events-sink task.
