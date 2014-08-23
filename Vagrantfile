# -*- mode: ruby -*-
# vi: set ft=ruby et ts=2 sw=2:

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "chef/debian-7.4"
  config.vm.network "private_network", ip: "192.168.27.10"
  config.vm.hostname = "test.ansible.pascutti.dev"
  # config.vm.synced_folder "../data", "/vagrant_data"

  config.vm.provider :virtualbox do |vb|
    vb.name = "ansible-tests"
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "test.yml"
  end
end
