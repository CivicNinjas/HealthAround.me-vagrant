# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    # Default config
    config.vm.box = "precise64"
    config.vm.box_url = "http://files.vagrantup.com/precise64.box"
    config.vm.synced_folder "salt/roots/", "/srv/"

    $script1 = <<SCRIPT
if grep -qv salt /etc/hosts; then
  echo "127.0.0.1 salt" >> /etc/hosts
fi
SCRIPT
    config.vm.provision :shell, :inline => $script1

    config.vm.provision :salt do |salt|
        salt.install_master = false
        salt.run_highstate = false
        salt.verbose = true
    end

    $script2 = <<SCRIPT
apt-get install git -y
cd /srv/salt
./setupsalt-minion
salt-call state.highstate
cd /var/www/healthroundme/
#~/.virtualenvs/healthgeist/bin/pip install django_extensions
./manage.py syncdb --noinput
./manage.py migrate
SCRIPT
    config.vm.provision :shell, :inline => $script2
end

Vagrant::Config.run do |config|
    config.vm.forward_port 80, 8080
end
