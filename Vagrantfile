# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.require_plugin "vagrant-aws"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64_puppet"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210.box"

  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :forwarded_port, guest: 8080, host: 8081
  config.vm.provider :virtualbox do |vb|
  #vb.gui = true  
  vb.customize ["modifyvm", :id, "--memory", "256"]
  end
  
  #Configure librarian-puppet
  config.vm.provider :virtualbox do |vb|
    # This allows symlinks to be created within the /vagrant root directory, 
    # which is something librarian-puppet needs to be able to do. This might
    # be enabled by default depending on what version of VirtualBox is used.
    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
  end
  
  config.vm.provider :aws do |aws, override|
    #dummy box for AWS:
    #config.vm.box = "dummy"    
	#config.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"

    aws.access_key_id = "AKIAJNTVXK5CH3P5JOHA"
    aws.secret_access_key = "DzK0GIIWKvzEHs+8nKZpCJUzVTSZ3QzA5SPTuIov"
    aws.keypair_name = "puppet"
    aws.region = "eu-west-1"
    aws.instance_type = "t1.micro"
    aws.ami = "ami-149f7863"
    aws.security_groups = [ 'vagrant' ]
    aws.user_data = "#!/bin/sh\nsed -i -e '/requiretty/ d' /etc/sudoers\n"	
    override.ssh.username = "ec2-user"
    override.ssh.private_key_path = "puppet/puppet.pem"
  end
  
  config.vm.provision :shell, :path => "shell/main.sh"
  
  config.vm.provision :puppet do |puppet|
        puppet.module_path = "puppet/modules"
        puppet.manifests_path = "puppet/manifests"
        puppet.manifest_file  = "default.pp"
  end
end
