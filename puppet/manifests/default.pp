group { "puppet":
	ensure => "present",
}

File { owner => 0, group => 0, mode => 0644 }
file { '/etc/motd':
	content => "Welcome to your Vagrant-built virtual machine for ReSTack! Managed by Puppet.\n"
}

include mongodb
include jenkins
include redis

#exec { "apt-get update":
#  path => "/usr/bin",
#}

