# minimal
# Shell script to create a minimal Django project.
# This project require Python3.

# Download:
# wget --output-document=minimal.sh

# Usage:
# Type the following command, you can change the project name.

# source minimal.sh

# Colors
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

# default name project
echo "Type the name of project (default: myproject): "
echo "Digite o nome do projeto (default: myproject): "
read p
PROJECT=${p:-myproject}

echo "${green}>>> Creating virtualenv${reset}"
python -m venv .venv
echo "${green}>>> .venv is created${reset}"

# active
sleep 2
echo "${green}>>> activate the .venv${reset}"
source .venv/bin/activate
PS1="(`basename \"$VIRTUAL_ENV\"`)\e[1;34m:/\W\e[00m$ "
sleep 2

# installdjango
echo "${green}>>> Installing the Django${reset}"
pip install -U pip
pip install django dj-database-url python-decouple django-extensions
pip freeze > requirements.txt

# Create contrib/secret_gen.py
echo "${green}>>> Creating the contrib/secret_gen.py${reset}"
mkdir -p contrib
cat << EOF > contrib/secret_gen.py
#!/usr/bin/env python

"""
Django SECRET_KEY generator.
"""
from django.utils.crypto import get_random_string


chars = 'abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*(-_=+)'

CONFIG_STRING = """
DEBUG=True
SECRET_KEY=%s
ALLOWED_HOSTS=127.0.0.1, .localhost
#DATABASE_URL=postgres://USER:PASSWORD@HOST:PORT/NAME
#DEFAULT_FROM_EMAIL=
#EMAIL_BACKEND=django.core.mail.backends.smtp.EmailBackend
#EMAIL_HOST=
#EMAIL_PORT=
#EMAIL_USE_TLS=
#EMAIL_HOST_USER=
#EMAIL_HOST_PASSWORD=
""".strip() % get_random_string(50, chars)

# Writing our configuration file to '.env'
with open('.env', 'w') as configfile:
    configfile.write(CONFIG_STRING)
EOF

echo "${green}>>> Generate .env${reset}"
python contrib/secret_gen.py

echo "${green}>>> Creating .gitignore${reset}"
cat << EOF > .gitignore
__pycache__/
*.py[cod]
*.sqlite3
*.env
*.DS_Store
.venv/
staticfiles/
.ipynb_checkpoints/
EOF

# Create Project
echo "${green}>>> Creating the project '$PROJECT' ...${reset}"
django-admin.py startproject $PROJECT .
cd $PROJECT
# Create App
echo "${green}>>> Creating the app 'core' ...${reset}"
python ../manage.py startapp core

# up one level
cd ..

# ********** Editing .env and settings.py **********
echo "${green}>>> Refactor .env${reset}"
# find SECRET_KEY
# grep "SECRET_KEY" $PROJECT/settings.py > .env
# replace =
# sed -i "s/ = /=/g" .env
# replace '
# sed -i "s/'//g" .env
# cat << EOF >> .env
# DEBUG=True
# ALLOWED_HOSTS=127.0.0.1, .localhost, .herokuapp.com
# EOF

echo "${green}>>> Editing settings.py${reset}"
# insert text in line below of string
sed -i "/import os/a\from decouple import config, Csv\nfrom dj_database_url import parse as dburl" $PROJECT/settings.py
# remove everything except the 1st n characters in every line - See more at: http://www.theunixschool.com/2014/08/sed-examples-remove-delete-chars-from-line-file.html#sthash.h7FUerys.dpuf
sed -i "/SECRET_KEY/d" $PROJECT/settings.py
# insert text in line below of string
sed -i "/keep the secret/a\SECRET_KEY = config('SECRET_KEY')" $PROJECT/settings.py
# replace text
sed -i "s/DEBUG = True/DEBUG = config('DEBUG', default=False, cast=bool)/g" $PROJECT/settings.py
sed -i "s/ALLOWED_HOSTS\ =\ \[\]/ALLOWED_HOSTS = config('ALLOWED_HOSTS', default=[], cast=Csv())/g" $PROJECT/settings.py
# insert text in line below of string
sed -i "/django.contrib.staticfiles/a\    # thirty apps\n    'django_extensions',\n    \# my apps\n    '$PROJECT.core'," $PROJECT/settings.py
# exclude lines
sed -i "/DATABASES/d" $PROJECT/settings.py
sed -i "/'default':/d" $PROJECT/settings.py
sed -i "/ENGINE/d" $PROJECT/settings.py
# exclude 3 lines
sed -i "/db.sqlite3/,+3d" $PROJECT/settings.py
# insert text after 'databases'
sed -i "/databases/a default_dburl = 'sqlite:///' + os.path.join(BASE_DIR, 'db.sqlite3')\nDATABASES = {\n    'default': config('DATABASE_URL', default=default_dburl, cast=dburl),\n}" $PROJECT/settings.py
# replace text
sed -i "s/en-us/pt-br/g" $PROJECT/settings.py
# replace text
sed -i "s/UTC/America\/Sao_Paulo/g" $PROJECT/settings.py
# insert text in line below of string
sed -i "/USE_TZ/a\\\nUSE_THOUSAND_SEPARATOR = True\n\nDECIMAL_SEPARATOR = ','" $PROJECT/settings.py
sed -i "/STATIC_URL/a\STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')\n\nLOGIN_URL = '/admin/login/'" $PROJECT/settings.py

# Create HttpResponse
cat << EOF > $PROJECT/core/views.py
from django.shortcuts import render
from django.http import HttpResponse


def home(request):
    return HttpResponse('Hello World')
EOF

# Create core/urls.py
cat << EOF > $PROJECT/core/urls.py
from django.conf.urls import url
from $PROJECT.core import views as c

urlpatterns = [
    url(r'^$', c.home, name='home'),
]
EOF

# Editing urls.py
cat << EOF > $PROJECT/urls.py
from django.conf.urls import include, url
from django.contrib import admin

urlpatterns = [
    url(r'', include('$PROJECT.core.urls', namespace='core')),
    url(r'^admin/', admin.site.urls),
]
EOF

# Running migrate
echo "${green}>>> Running migrate ...${reset}"
python manage.py migrate

# Running tests
echo "${green}>>> Running tests ...${reset}"
python manage.py test

echo "${green}>>> See the Makefile${reset}"
cat Makefile

echo "${red}>>> Important: Dont add .env in your public repository.${reset}"
echo "${red}>>> KEEP YOUR SECRET_KEY AND PASSWORDS IN SECRET!!!\n${reset}"
echo "${green}>>> Done${reset}"
