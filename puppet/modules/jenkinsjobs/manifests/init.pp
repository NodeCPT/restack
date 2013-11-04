class jenkinsjobs {
    file { '/var/lib/jenkins/jobs/setup-jenkins2':
        ensure => directory,
        mode => '0755',
        owner => 'jenkins',
        group => 'nogroup',
    }
	
	file { "/var/lib/jenkins/jobs/setup-jenkins2/config.xml":
        mode => "0644",
        owner => 'jenkins',
        group => 'nogroup',
        source => 'puppet:///modules/jenkinsjobs/config.xml',
    }
}