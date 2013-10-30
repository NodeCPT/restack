group { "puppet":
	ensure => "present",
}

File { owner => 0, group => 0, mode => 0644 }
file { '/etc/motd':
	content => "Welcome to your Vagrant-built virtual machine for ReSTack! Managed by Puppet.\n"
}

notice("Setting up MongoDB")
include mongodb

notice("Setting up Jenkins")
include jenkins

notice("Setting up Redis")
include redis

#exec { "apt-get update":
#  path => "/usr/bin",
#}
