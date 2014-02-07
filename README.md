# Healthgeist Vagrant

## Setup

1. [Install Vagrant](http://www.vagrantup.com)
2. `git clone git@github.com:CivicNinjas/SitegeistHealth-saltstack.git salt/roots/salt`
2. `git clone git@github.com:CivicNinjas/SitegeistHealth.git salt/roots/project`
3. `vagrant up`
4. `vagrant ssh`, and then:

        # Create database user w/ password
        sudo -u postgres createuser --createdb --pwprompt healthgeist

        # Grant user access to the database
        sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE healthgeist TO healthgeist";

        # Install interface libraries
        sudo apt-get install libpq-dev

        # Setup the project
        cd /srv/project
        cp settings_override.example.py settings_override.py
        vi settings_override.py  # See below
        sudo pip install virtualenvwrapper
        source /usr/local/bin/virtualenvwrapper.sh
        mkvirtualenv healthgeist
        setvirtualenvproject
        pip install -r requirements.txt
        pip install -r requirements-dev.txt
        pip install django_extensions
        ./manage.py syncdb  # Also setup your admin user
        ./manage.py migrate

        # Run the service
        ./manage.py runserver

5. Open a browser and go to <http://localhost:8080>.
   <http://localhost:8080/admin> may also be interesting.

## Sample settings_override.py
Here's a sample `settings_override.py`:

    DEBUG = True
    TEMPLATE_DEBUG = True
    
    ALLOWED_HOSTS = ['localhost']
    
    SECRET_KEY = 'A_random_string_not_this_one'  # Get this from another developer
    
    LOCAL_INSTALLED_APPS = ('django_extensions',)
    LOCAL_MIDDLEWARE_CLASSES = ()
    
    DATABASES = {
        'default': {
            'ENGINE': 'django.contrib.gis.db.backends.postgis',
            'NAME': 'healthgeist',
            'USER': 'healthgeist',
            'PASSWORD': 'password',
            'HOST': 'localhost',
            'PORT': '5432',
        }
    }
