def project = 'NodeCPT/restack'
def branchApi = new URL("https://api.github.com/repos/${project}/branches")

def branchName = "master"
def mainBuild = "${project}-${branchName}".replaceAll('/','-')
def mainBuildDeploy = "${mainBuild} - Deploy latest build"

job {
	name "${mainBuildDeploy}"
	steps {
		shell('mkdir -p /var/www/restack/build_${BUILD_NUMBER}_${BUILD_ID}')
		copyArtifacts("${mainBuild}", "", "/var/www/restack/build_${BUILD_NUMBER}_${BUILD_ID}", false, false) { latestSuccessful(); }
		shell('rm -rf /var/www/restack/current')
		shell('ln -s /var/www/restack/build_${BUILD_NUMBER}_${BUILD_ID} /var/www/restack/current')
	}
}

job {
	name "${mainBuild}"
	scm {
		git("git://github.com/${project}.git", branchName)
	}
	triggers {
		scm("H/15 * * * *")
	}
	steps {
		shell("npm install")
		shell("npm test")
	}
	publishers {
		archiveArtifacts("**/*.js, node_modules/**, package.json", "test/**", false)
		downstream("${mainBuildDeploy}", "SUCCESS")
	}
}



//NODE_BUILD_NUMBER=$(curl http://localhost:8080/job/NodeCPT-restack-master/lastStableBuild/buildNumber) && echo $NODE_BUILD_NUMBER
//readlink -f latest

//def branches = new groovy.json.JsonSlurper().parse(branchApi.newReader())
//branches.each { 
//    def branchName = it.name
//    job {
//        name "${project}-${branchName}".replaceAll('/','-')
//        scm {
//            git("git://github.com/${project}.git", branchName)
//        }
//        steps {
//            maven("test -Dproject.name=${project}/${branchName}")
//        }
//    }
//}

//		shell('NODE_BUILD_NUMBER=$(curl http://localhost:8080/job/' + "${mainBuild}" + '/lastStableBuild/buildNumber)')
//		shell('mkdir -p /var/www/restack/build_$NODE_BUILD_NUMBER')
		//shell('rm -rf /var/www/restack/latest')
		//shell('ln -s /var/www/restack/build_$NODE_BUILD_NUMBER /var/www/restack/latest')
