# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  config.vm.box = "precise64"
  config.vm.hostname = 'web.developer.vm'
  config.vm.network :private_network, ip: "192.168.33.10"

  config.vm.provision :puppet do |puppet|
    puppet.options = ['--verbose']    
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file  = "default.pp"
    puppet.facter = { 'fqdn' => config.vm.hostname }
  end
  
end
