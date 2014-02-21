# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
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

# Create database user w/ password 'healthgeist'
sudo -u postgres psql -c "CREATE ROLE healthgeist PASSWORD 'md557fc582527ea88f020934752bb7f9f3b' NOSUPERUSER CREATEDB NOCREATEROLE INHERIT LOGIN";

# Grant user access to the database
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE healthgeist TO healthgeist";

# Install interface libraries
sudo apt-get install libpq-dev -y

# Setup the project
cd /srv/project
echo "
DEBUG = True
TEMPLATE_DEBUG = True

ALLOWED_HOSTS = ['localhost']

SECRET_KEY = 'This_is_not_a_good_secret_key'

LOCAL_INSTALLED_APPS = ('django_extensions',)
LOCAL_MIDDLEWARE_CLASSES = ()

DATABASES = {
    'default': {
        'ENGINE': 'django.contrib.gis.db.backends.postgis',
        'NAME': 'healthgeist',
        'USER': 'healthgeist',
        'PASSWORD': 'healthgeist',
        'HOST': 'localhost',
        'PORT': '5432',
    }
}" > /srv/project/settings_override.py
sudo pip install virtualenvwrapper
echo "source /usr/local/bin/virtualenvwrapper.sh" >> /home/vagrant/.bash_profile

sudo su vagrant -c "
cd /srv/project
source /usr/local/bin/virtualenvwrapper.sh
mkvirtualenv healthgeist
setvirtualenvproject
~/.virtualenvs/healthgeist/bin/pip install -r /srv/project/requirements.txt
~/.virtualenvs/healthgeist/bin/pip install -r /srv/project/requirements-dev.txt
~/.virtualenvs/healthgeist/bin/pip install django_extensions
./manage.py syncdb --noinput
./manage.py migrate
"
SCRIPT
    config.vm.provision :shell, :inline => $script2
end

Vagrant::Config.run do |config|
    config.vm.forward_port 80, 8080
end
