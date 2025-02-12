[[- define "full_args" -]]
[[- $task := var "task" . ]]
[[- $fullArgs := prepend $task.additional_cli_args "agent" -]]
[[- if $task.scaling_policy_files ]][[ $fullArgs = append $fullArgs "-policy-dir=${NOMAD_TASK_DIR}/policies" ]][[- end -]]
[[- if $task.config_files ]][[ $fullArgs = append $fullArgs "-config=${NOMAD_TASK_DIR}/config" ]][[- end -]]
[[ $fullArgs | toPrettyJson ]]
[[- end -]]
