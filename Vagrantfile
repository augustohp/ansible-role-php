# -*- mode: ruby -*-
# vi: set ft=ruby et ts=2 sw=2:

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.synced_folder "web", "/var/www/default"

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  # Debian 7
  config.vm.define "wheezy54", primary: true, autostart: true do |debian|
    debian.vm.box = "chef/debian-7.4"
    debian.vm.network "private_network", ip: "192.168.27.10"
    debian.vm.hostname = "wheezy54.debian.local"

    debian.vm.provider :virtualbox do |vb|
      vb.name = "ansible-php54-role-debian-wheezy"
    end

    debian.vm.provision "ansible" do |local|
      local.playbook = "test.yml"
      local.extra_vars = {
        "hwr_options.install_composer" => "false",
        "hwr_options.php_version" => "5.4"
      }
    end
  end

  # Debian 7
  config.vm.define "wheezy55", primary: true, autostart: true do |debian|
    debian.vm.box = "chef/debian-7.4"
    debian.vm.network "private_network", ip: "192.168.27.11"
    debian.vm.hostname = "wheezy55.debian.local"

    debian.vm.provider :virtualbox do |vb|
      vb.name = "ansible-php55-role-debian-wheezy"
    end

    debian.vm.provision "ansible" do |local|
      local.playbook = "test.yml"
      local.extra_vars = {
        "hwr_options.install_composer" => "false",
        "hwr_options.php_version" => "5.5"
      }
    end
  end

  # Debian 6
  config.vm.define "squeeze53", autostart: false do |debian|
    debian.vm.box = "chef/debian-6.0.8"
    debian.vm.network "private_network", ip: "192.168.27.21"
    debian.vm.hostname = "squeeze53.debian.local"

    debian.vm.provider :virtualbox do |vb|
      vb.name = "ansible-php53-role-debian-squeeze"
    end

    debian.vm.provision "ansible" do |local|
      local.playbook = "test.yml"
      local.extra_vars = {
        "hwr_options.install_composer" => "false",
        "hwr_options.php_version" => "5.3"
      }
    end
  end

  # Debian 6
  config.vm.define "squeeze54", autostart: false do |debian|
    debian.vm.box = "chef/debian-6.0.8"
    debian.vm.network "private_network", ip: "192.168.27.22"
    debian.vm.hostname = "squeeze54.debian.local"

    debian.vm.provider :virtualbox do |vb|
      vb.name = "ansible-php54-role-debian-squeeze"
    end

    debian.vm.provision "ansible" do |local|
      local.playbook = "test.yml"
      local.extra_vars = {
        "hwr_options.install_composer" => "false",
        "hwr_options.php_version" => "5.4"
      }
    end
  end

  # Ubuntu 12.04 LTS
  config.vm.define "precise53", autostart: false do |ubuntu|
    ubuntu.vm.box = "precise64"
    ubuntu.vm.network "private_network", ip: "192.168.27.30"
    ubuntu.vm.hostname = "precise53.ubuntu.local"

    ubuntu.vm.provider :virtualbox do |vb|
      vb.name = "ansible-php53-role-ubuntu-precise"
    end

    ubuntu.vm.provision "ansible" do |local|
      local.playbook = "test.yml"
      local.extra_vars = {
        "hwr_options.install_composer" => "false",
        "hwr_options.php_version" => "5.3"
      }
    end
  end

  # Ubuntu 12.04 LTS
  config.vm.define "precise54", autostart: false do |ubuntu|
    ubuntu.vm.box = "precise64"
    ubuntu.vm.network "private_network", ip: "192.168.27.31"
    ubuntu.vm.hostname = "precise54.ubuntu.local"

    ubuntu.vm.provider :virtualbox do |vb|
      vb.name = "ansible-php54-role-ubuntu-precise"
    end

    ubuntu.vm.provision "ansible" do |local|
      local.playbook = "test.yml"
      local.extra_vars = {
        "hwr_options.install_composer" => "false",
        "hwr_options.php_version" => "5.4"
      }
    end
  end

  # Ubuntu 12.04 LTS
  config.vm.define "precise55", autostart: false do |ubuntu|
    ubuntu.vm.box = "precise64"
    ubuntu.vm.network "private_network", ip: "192.168.27.32"
    ubuntu.vm.hostname = "precise55.ubuntu.local"

    ubuntu.vm.provider :virtualbox do |vb|
      vb.name = "ansible-php55-role-ubuntu-precise"
    end

    ubuntu.vm.provision "ansible" do |local|
      local.playbook = "test.yml"
      local.extra_vars = {
        "hwr_options.install_composer" => "false",
        "hwr_options.php_version" => "5.5"
      }
    end
  end

  # Ubuntu 14.04 LTS
  config.vm.define "trusty55", primary: true, autostart: true do |ubuntu|
    ubuntu.vm.box = "ubuntu/trusty64"
    ubuntu.vm.network "private_network", ip: "192.168.27.40"
    ubuntu.vm.hostname = "trusty55.ubuntu.local"

    ubuntu.vm.provider :virtualbox do |vb|
      vb.name = "ansible-php55-role-ubuntu-trusty"
    end

    ubuntu.vm.provision "ansible" do |local|
      local.playbook = "test.yml"
      local.extra_vars = {
        "hwr_options.install_composer" => "false",
        "hwr_options.php_version" => "5.5"
      }
    end  end

  # CentOS 6
  config.vm.define "centos6", autostart: false do |ubuntu|
    ubuntu.vm.box = "chef/centos-6.5"
    ubuntu.vm.network "private_network", ip: "192.168.27.14"
    ubuntu.vm.hostname = "6-5.centos.local"

    ubuntu.vm.provider :virtualbox do |vb|
      vb.name = "ansible-php-role-centos-6.5"
    end
  end
end
