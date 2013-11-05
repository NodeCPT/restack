group { "puppet":
	ensure => "present",
}

include 'motd'
#include upstartjobs
include jenkinsconfig


### Start of the node server configs. Would normally be a different server ###

class { 'mongodb':
  init => 'upstart',
  enable_10gen => true,
}

#include redis
class { 'nodejs':
	manage_repo => true,
}

#exec { "apt-get update":
#  path => "/usr/bin",
#}
