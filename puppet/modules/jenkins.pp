notice("Setting up Jenkins")
class {jenkins:
    url => "http://127.0.0.1",
    email_address => "ci@example.com",
	slaves => ["jenkins-slave01", "jenkins-slave02"],
    views => [
      ["All", ".*"],
      ["Master", ".*master.*"],
      ["Release", ".*release.*"],
    ]
}

notice("Setting up Jenkins - Plugins")
jenkins::plugin { "port-allocator": version => "1.5" }
jenkins::plugin { "git" : ; }

notice("Setting up Jenkins - Jobs")

jenkins::job { "app1_master":
  git_repo => "https://github.com/user/app1",
  git_branch => "master",
  command => "./ci.sh",
  triggers => ["app1_master_integration"]
}

jenkins::job { "app1_master_integration":
  git_repo => "https://github.com/user/app1",
  git_branch => "master",
  command => "./ci.sh integration",
  poll => false,
  build_schedule => "H H * * *"
}
