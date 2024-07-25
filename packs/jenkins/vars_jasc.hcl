docker_jenkins_env_vars = {
  "java_opts": "-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false",
}
jasc_config = <<EOF
jenkins:
  numExecutors: 2
jobs:
  - script: >
      job('jobdsl_test') {
        steps {
            shell('whoami')
        }
      }
EOF
plugins = ["configuration-as-code", "job-dsl"]
register_consul_service = true
volume_name = "jenkins"
