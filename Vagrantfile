# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  config.vm.box = "ubuntu/bionic64"
  config.vm.hostname = 'web.developer.dev'
  config.vm.network :forwarded_port, guest: 80, host: 4545
  config.vm.network :forwarded_port, guest: 9292, host: 4646
  
  config.vm.synced_folder ".", "/var/www/app"

  config.vm.provision "shell", :inline => <<-SHELL
    apt-get update
    apt-get install -y puppet
  SHELL

  config.vm.provision :puppet do |puppet|
    puppet.options = ['--verbose']
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file  = "default.pp"
    puppet.facter = { 'fqdn' => config.vm.hostname }
  end
  
end
