# -*- mode: ruby -*-
# vi: set ft=ruby et ts=2 sw=2:

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.synced_folder "web", "/var/www/default"

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "test.yml"
  end

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  # Debian 7
  config.vm.define "wheezy", primary: true, autostart: true do |debian|
    debian.vm.box = "chef/debian-7.4"
    debian.vm.network "private_network", ip: "192.168.27.10"
    debian.vm.hostname = "php-role.wheezy.debian.local"

    debian.vm.provider :virtualbox do |vb|
      vb.name = "ansible-php-role-debian-wheezy"
    end
  end

  # Debian 6
  config.vm.define "squeeze", autostart: false do |debian|
    debian.vm.box = "chef/debian-6.0.8"
    debian.vm.network "private_network", ip: "192.168.27.11"
    debian.vm.hostname = "php-role.squeeze.debian.local"

    debian.vm.provider :virtualbox do |vb|
      vb.name = "ansible-php-role-debian-squeeze"
    end
  end

  # Ubuntu 12.04 LTS
  config.vm.define "precise", autostart: false do |ubuntu|
    ubuntu.vm.box = "precise64"
    ubuntu.vm.network "private_network", ip: "192.168.27.11"
    ubuntu.vm.hostname = "php-role.precise.ubuntu.local"

    ubuntu.vm.provider :virtualbox do |vb|
      vb.name = "ansible-php-role-ubuntu-precise"
    end
  end

  # Ubuntu 14.04 LTS
  config.vm.define "trusty", primary: true, autostart: true do |ubuntu|
    ubuntu.vm.box = "ubuntu/trusty64"
    ubuntu.vm.network "private_network", ip: "192.168.28.13"
    ubuntu.vm.hostname = "php-role.trusty.ubuntu.local"

    ubuntu.vm.provider :virtualbox do |vb|
      vb.name = "ansible-php-role-ubuntu-trusty"
    end
  end

  # CentOS 6
  config.vm.define "centos6", autostart: false do |ubuntu|
    ubuntu.vm.box = "chef/centos-6.5"
    ubuntu.vm.network "private_network", ip: "192.168.28.14"
    ubuntu.vm.hostname = "php-role.6-5.centos.local"

    ubuntu.vm.provider :virtualbox do |vb|
      vb.name = "ansible-php-role-centos-6.5"
    end
  end

end
