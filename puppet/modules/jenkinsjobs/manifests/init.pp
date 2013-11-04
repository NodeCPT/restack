class jenkinsjobs {
    file { '/var/lib/jenkins/jobs/setup-jenkins':
        ensure => directory,
        mode => '0755',
        owner => 'jenkins',
        group => 'nogroup',
    }
	
	file { "/var/lib/jenkins/jobs/setup-jenkins/config.xml":
        mode => "0644",
        owner => 'jenkins',
        group => 'nogroup',
        source => 'puppet:///modules/jenkinsjobs/config.xml',
    }
	
	exec {'reload-jenkins':
		command => "/usr/bin/curl -X POST http://localhost:8080/reload",
		require => File["/var/lib/jenkins/jobs/setup-jenkins/config.xml"],
		notify => Exec["sleep-2s"],
	}
	
	exec {'sleep-2s':
		command => "/bin/sleep 2s",
		notify => Exec["run-setup-job"],
	}
	
	exec {'run-setup-job':
		command => "/usr/bin/curl -X GET http://localhost:8080/job/setup-jenkins/build?delay=0sec",
	}	
}