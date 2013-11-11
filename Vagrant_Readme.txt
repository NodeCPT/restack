Notes:
======
To use the Vagrant / Puppet scripts, you need to have Vagrant, Puppet and VirtualBox (if running locally) installed. To start everything up, simply run:
vagrant up


For AWS:
========
You will need to do the following first:
1. Create an Access Key pair.
2. On AWS:
2.1. Create a security group called 'puppet' with SSH access to your ip / 0.0.0.0.
2.2. Create a keypair called puppet.
3. Update VagrantFile with your details - I will see if I can extract these values into a seperate file that you can then .gitignore.

To start up an Amazon instance, simply run:
vagrant up --provider=aws