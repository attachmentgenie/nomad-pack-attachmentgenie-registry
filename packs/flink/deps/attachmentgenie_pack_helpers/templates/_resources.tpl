[[- /*

## `resources` helper

*/ -]]

[[ define "resources" -]]
[[- $resources := var "task_resources" . ]]
      resources {
        cpu    = [[ $resources.cpu ]]
        memory = [[ $resources.memory ]]
      }
[[- end ]]
