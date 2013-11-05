class jenkinsconfig {

	class { 'jenkins':
		require => [ 
			File["/var/run/jenkins"],
        ]
	}

	class jenkinsconfig::jenkinsplugins {
		jenkins::plugin { "port-allocator": version => "1.5" } 
		jenkins::plugin { "scm-api" : ; }
		jenkins::plugin { "git-client" : ; }
		jenkins::plugin { "git" : ; }
		jenkins::plugin { "job-dsl" : ; }
		jenkins::plugin { "copyartifact" : ; }		
	}
	
	include jenkinsconfig::jenkinsplugins
		
    file { '/var/run/jenkins':
        ensure => directory,
        mode => '0755',
        owner => 'root',
        group => 'root',
    }

	file { '/var/www/restack':
        ensure => directory,
        mode => '0755',
        owner => 'jenkins',
        group => 'nogroup',
    }
	
	
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
        source => 'puppet:///modules/jenkinsconfig/config.xml',
    }

	exec {'sleep-10s':
		command => "/bin/sleep 10s",
		notify => Exec["reload-jenkins"],
	}

	exec {'reload-jenkins':
		command => "/usr/bin/curl -X POST http://localhost:8080/reload",
		require => [
			File["/var/lib/jenkins/jobs/setup-jenkins/config.xml"],
			File["/var/www/restack"],
			Class["jenkinsconfig::jenkinsplugins"],
		],
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