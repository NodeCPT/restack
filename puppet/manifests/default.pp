### MOTD ###
notice("Setting the MOTD")
group { "puppet":
	ensure => "present",
}

File { owner => 0, group => 0, mode => 0644 }
file { '/etc/motd':
	content => "Welcome to your Vagrant-built virtual machine for ReSTack! Managed by Puppet.\n"
}
### END ###

### Jenkins ###
notice("Setting up Jenkins")
include jenkins
notice("Setting up Jenkins - Plugins")
jenkins::plugin { "port-allocator": version => "1.5" }
jenkins::plugin { "git" : ; }
jenkins::plugin { "job-dsl" : ; }
### END ###

### Mongo ###
notice("Setting up Mongo from 10gen repo")
class { 'mongodb':
  init => 'upstart',
  enable_10gen => true,
}
### END ###

notice("Setting up Redis")
include redis

#exec { "apt-get update":
#  path => "/usr/bin",
#}
