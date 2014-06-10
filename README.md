# Healthgeist Vagrant

This project will help you get the Healthgeist code running in a virtual
environment.  This is useful for local development of the project or of the
system configuration scripts.

## Setup

1. [Install Vagrant](http://www.vagrantup.com)
2. `git clone git@github.com:CivicNinjas/HealthAround.me-saltstack.git salt/roots/salt`
2. `git clone git@github.com:CivicNinjas/HealthAround.me.git salt/roots/project`
3. `vagrant up`
4. `vagrant ssh`, and then:

        sudo service supervisor stop
        sudo service supervisor start
        cd /var/www/healthgeist
        ./manage.py createsuperuser

5. Open a browser and go to <http://localhost:8080>.
   <http://localhost:8080/admin> may also be interesting.
