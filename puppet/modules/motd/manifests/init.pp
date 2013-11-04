class motd() {
	file { "/etc/motd":
		owner => 0, 
		group => 0, 
		mode => "0644",
		source => 'puppet:///modules/motd/motd',
	}
}