group { "puppet":
	ensure => "present",
}

include 'motd'

include jenkins
jenkins::plugin { "port-allocator": version => "1.5" } 
jenkins::plugin { "scm-api" : ; }
jenkins::plugin { "git" : ; }
jenkins::plugin { "job-dsl" : ; }
include jenkinsjobs

class { 'mongodb':
  init => 'upstart',
  enable_10gen => true,
}

include redis

#exec { "apt-get update":
#  path => "/usr/bin",
#}
