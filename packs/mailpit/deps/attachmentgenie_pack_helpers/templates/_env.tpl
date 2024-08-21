[[- define "env_upper" -]]
  env {
    [[ range $key, $var := var "env_vars" . ]]
    [[if ne (len $var) 0 ]][[ $key | upper ]] = [[ $var | quote ]][[ end ]]
    [[ end ]]
  }
[[- end -]]
