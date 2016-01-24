# Shell script to create a full Django project.
# The project contains:
# Core App
# Person Model
# Person List
# Person Detail
# Person Form
# Person Admin
# API REST
# Tests with Selenium
# Fixtures with Generate Random Values
# New commands with django-admin

# Download: wget --output-document=setupfull.sh URL_NAME

# Usage: source setupfull.sh

# Colors
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

# default name project
echo "Type the name of project (default: myproject): "
echo "Digite o nome do projeto (default: myproject): "
read p
PROJECT=${p-myproject}

echo "${green}>>> Remove .venv${reset}"
rm -rf .venv

echo "${green}>>> Remove djangoproject${reset}"
rm -rf djangoproject

echo "${green}>>> Creating djangoproject.${reset}"
mkdir djangoproject
cd djangoproject

echo "${green}>>> Creating virtualenv${reset}"
virtualenv -p python3 .venv
echo "${green}>>> venv is created.${reset}"

# active
sleep 2
echo "${green}>>> activate the venv.${reset}"
source .venv/bin/activate

echo "${green}>>> Short the prompt path.${reset}"
PS1="(`basename \"$VIRTUAL_ENV\"`)\e[1;34m:/\W\e[00m$ "
sleep 2

# installdjango
echo "${green}>>> Installing the Django${reset}"
pip install django djangorestframework django-bootstrap-form django-daterange-filter selenium names rstr pytz
pip freeze > requirements.txt

# createproject
echo "${green}>>> Creating the project '$PROJECT' ...${reset}"
django-admin.py startproject $PROJECT .
cd $PROJECT
echo "${green}>>> Creating the app 'core' ...${reset}"
python ../manage.py startapp core
cd ..

# migrate
python manage.py migrate

# createuser
echo "${green}>>> Creating a 'admin' user ...${reset}"
echo "${green}>>> The password must contain at least 8 characters.${reset}"
echo "${green}>>> Password suggestions: djangoadmin${reset}"
python manage.py createsuperuser --username='admin' --email=''


echo "${green}>>> Editing settings.py${reset}"
sed -i "/django.contrib.staticfiles/a\    '$PROJECT.core'," $PROJECT/settings.py


echo "${green}>>> Editing urls.py${reset}"
cat << 'EOF' > $PROJECT/urls.py
from django.conf.urls import url
from django.contrib import admin
import PROJECT.core.views as v

urlpatterns = [
    url(r'^$', v.home, name='home'),
    url(r'^person/$', v.PersonList.as_view(), name='person_list'),
    url(r'^person/(?P<pk>\d+)/$', v.PersonDetail.as_view(), name='person_detail'),
    url(r'^person/add/$', v.PersonCreate.as_view(), name='person_add'),
    url(r'^admin/', admin.site.urls),
]
EOF

# Editing urls.py
sed -i "s/PROJECT/$PROJECT/" $PROJECT/urls.py

echo "${green}>>> Editing views.py${reset}"
cat << 'EOF' > $PROJECT/core/views.py
from django.shortcuts import render
from django.http import HttpResponse
from django.core.urlresolvers import reverse_lazy
from django.views.generic import CreateView, TemplateView, ListView, DetailView
from PROJECT.core.models import Person


def home(request):
    return render(request, 'index.html')


class PersonList(ListView):
    template_name = 'core/person_list.html'
    model = Person
    context_object_name = 'persons'


class PersonCreate(CreateView):
    template_name = 'core/person_form.html'
    model = Person
    fields = '__all__'
    success_url = reverse_lazy('person_list')


class PersonDetail(DetailView):
    template_name = 'core/person_detail.html'
    model = Person
EOF

# Editing views.py
sed -i "s/PROJECT/$PROJECT/" $PROJECT/core/views.py



echo "${green}>>> Editing models.py${reset}"
cat << 'EOF' > $PROJECT/core/models.py
from django.db import models
from django.core.urlresolvers import reverse_lazy

gender_list = [('M', 'male'), ('F', 'female')]

class TimeStampedModel(models.Model):
    created = models.DateTimeField(auto_now_add=True, auto_now=False)
    modified = models.DateTimeField(auto_now_add=False, auto_now=True)

    class Meta:
        abstract = True


class Person(TimeStampedModel):
    gender = models.CharField(max_length=1, choices=gender_list)
    first_name = models.CharField('first name', max_length=30)
    last_name = models.CharField('last name', max_length=30)
    birthday = models.DateTimeField(null=True, blank=True)
    email = models.EmailField(blank=True)
    phone = models.CharField(max_length=20, default='')
    blocked = models.BooleanField(default=False)

    class Meta:
        ordering = ['first_name']
        verbose_name = 'contact'
        verbose_name_plural = 'contacts'

    def __str__(self):
        return "{} {}".format(self.first_name, self.last_name)

    full_name = property(__str__)

    def get_absolute_url(self):
        ''' return id '''
        return reverse_lazy('person_detail', kwargs={'pk': self.pk})
EOF


echo "${green}>>> Editing admin.py${reset}"
cat << 'EOF' > $PROJECT/core/admin.py
from django.contrib import admin
from .models import Person

admin.site.register(Person)
EOF


echo "${green}>>> Editing forms.py${reset}"
cat << 'EOF' > $PROJECT/core/forms.py
from django import forms
from .models import Person

gender_list = [('M', 'male'), ('F', 'female')]


class PersonForm(forms.ModelForm):
    gender = forms.ChoiceField(
        choices=gender_list, initial='M', widget=forms.RadioSelect)

    class Meta:
        model = Person
        fields = '__all__'

    def clean_cpf(self):
        return self.cleaned_data['cpf'] or None
EOF


echo "${green}>>> Creating templates${reset}"
mkdir -p $PROJECT/core/templates/core
touch $PROJECT/core/templates/{base.html,menu.html,index.html,pagination.html}
touch $PROJECT/core/templates/core/{person_list.html,person_detail.html,person_form.html}


echo "${green}>>> Migrating${reset}"
python manage.py makemigrations
python manage.py migrate

echo "${green}>>> Editing base.html${reset}"

cat << 'EOF' > $PROJECT/core/templates/base.html
<!DOCTYPE html>
<html lang="en">
  <head>
    {% load static %}

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="shortcut icon" href="https://www.djangoproject.com/favicon.ico">


    {% block title %}
      <title>Django Example</title>
    {% endblock title %}

    <!-- Bootstrap core CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-2.1.4.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>

    <style type="text/css">
      /* Move down content because we have a fixed navbar that is 60px tall */
      body {
        padding-top: 60px;
        padding-bottom: 40px;
      }
    </style>

  </head>
  <body>

    {% include "menu.html" %}

    {% block content %}
      
    {% endblock content %}
  </body>
</html>
EOF



echo "${green}>>> Editing menu.html${reset}"

cat << 'EOF' > $PROJECT/core/templates/menu.html
<!-- Menu -->
<div class="navbar navbar-inverse navbar-fixed-top" role="navigation">
  <div class="container-fluid">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
    </div>
    <div class="navbar-collapse collapse">
      <ul class="nav navbar-nav">
        <li class="current"><a href="{% url 'home' %}"><span class="glyphicon glyphicon-home"></span> Home</a></li>
        <li><a href="{% url 'person_list' %}"><span class="glyphicon glyphicon-user"></span> Contacts</a></li>
      </ul>
      <ul class="nav navbar-nav navbar-right">
        <li><a href="{% url 'admin:index' %}">Admin</a></li>
      </ul>
    </div>
  </div>
</div>
EOF



echo "${green}>>> Editing index.html${reset}"

cat << 'EOF' > $PROJECT/core/templates/index.html
{% extends "base.html" %}

{% block content %}
    <div class="container">
        <div class="jumbotron">
            <h1>Contacts</h1>
            <h3>Contacts list make in Django.</h3>
            <p>The project contains:</p>
            <ul>
            <li>Core App</li>
            <li>Person Model</li>
            <li>Person List</li>
            <li>Person Detail</li>
            <li>Person Form</li>
            <li>Person Admin</li>
            <li>API REST</li>
            <li>Tests with Selenium</li>
            <li>Fixtures with Generate Random Values</li>
            <li>New commands with django-admin</li>
            </ul>
        </div>
    </div>
{% endblock content %}
EOF



echo "${green}>>> Editing pagination.html${reset}"

cat << 'EOF' > $PROJECT/core/templates/pagination.html
<!-- pagination -->
<div class="row text-center">
    <div class="col-lg-12">
        <ul class="pagination">
            {% if page_obj.has_previous %}
                <li><a href="?page={{ page_obj.previous_page_number }}">&laquo;</a></li>
            {% endif %}
            {% for pg in page_obj.paginator.page_range %}
                {% if page_obj.number == pg %}
                    <li class="active"><a href="?page={{ pg }}">{{ pg }}</a></li>
                {% else %}
                    <li><a href="?page={{ pg }}">{{ pg }}</a></li>
                {% endif %}
            {% endfor %}
            {% if page_obj.has_next %}
                <li><a href="?page={{ page_obj.next_page_number }}">&raquo;</a></li>
            {% endif %}
        </ul>
    </div>
</div>
EOF



echo "${green}>>> Editing person_list.html${reset}"

cat << 'EOF' > $PROJECT/core/templates/core/person_list.html
{% extends "base.html" %}

{% block content %}

<div class="container">

    <div class="page-header">
        <a class="btn btn-primary pull-right" href="{% url 'person_add' %}"><i class="glyphicon glyphicon-plus"></i> Add Person</a>
    </div>

    {% if persons %}
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Birthday</th>
                    <th class="text-center">Blocked</th>
                </tr>
            </thead>
            <tbody>
            {% for person in persons %}
                <tr>
                    <td><a href="{{ person.get_absolute_url }}">{{ person.full_name }}</a></td>
                    <td>{{ person.email }}</td>
                    <td>{{ person.phone }}</td>
                    <td>{{ person.birthday|date:"d/m/Y" }}</td>
                    {% if person.blocked %}
                        <td class="text-center"><span class="glyphicon glyphicon-ok-sign" style="color: #44AD41"></span></td>
                    {% else %}
                        <td class="text-center"><span class="glyphicon glyphicon-minus-sign" style="color: #DE2121"></span></td>
                    {% endif %}
                </tr>
            {% endfor %}
            </tbody>
        </table>
    {% else %}
        <p class="alert alert-warning">Without items in this list.</p>
    {% endif %}
</div>
{% endblock content %}
EOF


echo "${green}>>> Editing person_detail.html${reset}"

cat << 'EOF' > $PROJECT/core/templates/core/person_detail.html
{% extends "base.html" %}

{% load static %}

{% block title %}
    <title>Person Detail</title>
{% endblock title %}

{% block content %}

<form class="navbar-form navbar-right" action="." method="get">
    <!-- edit -->
    <a href="{% url 'person_edit' pk=person.id %}">
        <button id="edit_person" type="button" class="btn btn-success">
            <span class="fa fa-pencil"></span> Editar
        </button>
    </a>
</form>
    
<div class="col-lg-8">
    <div class="col-md-2 column">
        <img src="{% static "img/person128.png" %}" class="img-square" />
    </div>
    <div class="col-md-offset-3 column">
        {% if object.treatment %}
            <h1>{{ object.get_treatment_display }} {{ object.full_name }}</h1>
        {% else %}
            <h1>{{ object.full_name }}</h1>
        {% endif %}
        {% if object.email %}
            <h4><span class="glyphicon glyphicon-envelope"></span><a href="#"> {{ object.email }}</a></h4>
        {% endif %}
    </div>

    </br>

    <table class="table table-user-information">
        <tbody>
            <tr>
                <th class="col-md-3 text-right">Gênero</th>
                <td>{{ object.get_gender_display }}</td>
            </tr>
            {% if object.company %}
                <tr>
                    <th class="col-md-3 text-right">Empresa</th>
                    <td>{{ object.company }}</td>
                </tr>
            {% endif %}
            {% if object.occupation %}
                <tr>
                    <th class="col-md-3 text-right">Cargo</th>
                    <td>{{ object.occupation }}</td>
                </tr>
            {% endif %}
            {% if object.department %}
                <tr>
                    <th class="col-md-3 text-right">Departamento</th>
                    <td>{{ object.department }}</td>
                </tr>
            {% endif %}
            {% if object.phone1 %}
                <tr>
                    <th class="col-md-3 text-right">Telefone 1</th>
                    <td>{{ object.phone1 }}</td>
                </tr>
            {% else %}
                <tr>
                    <th class="col-md-3 text-right">Telefone 1</th>
                    <td>---</td>
                </tr>
            {% endif %}
            {% if object.phone2 %}
                <tr>
                    <th class="col-md-3 text-right">Telefone 2</th>
                    <td>{{ object.phone2 }}</td>
                </tr>
            {% endif %}
            {% if object.phone3 %}
                <tr>
                    <th class="col-md-3 text-right">Telefone 3</th>
                    <td>{{ object.phone3 }}</td>
                </tr>
            {% endif %}
            {% if object.cpf %}
                <tr>
                    <th class="col-md-3 text-right">CPF</th>
                    <td>{{ object.cpf }}</td>
                </tr>
            {% endif %}
            {% if object.rg %}
                <tr>
                    <th class="col-md-3 text-right">RG</th>
                    <td>{{ object.rg }}</td>
                </tr>
            {% endif %}
            {% if object.cnpj %}
                <tr>
                    <th class="col-md-3 text-right">CNPJ</th>
                    <td>{{ object.cnpj }}</td>
                </tr>
            {% endif %}
            {% if object.ie %}
                <tr>
                    <th class="col-md-3 text-right">IE</th>
                    <td>{{ object.ie }}</td>
                </tr>
            {% endif %}
            <tr>
                <th class="col-md-3 text-right">Ativo</th>
                {% if object.active %}
                    <td><span class="glyphicon glyphicon-ok-sign" style="color: #44AD41"></span></td>
                {% else %}
                    <td><span class="glyphicon glyphicon-minus-sign" style="color: #DE2121"></span></td>
                {% endif %}
            </tr>
            <tr>
                <th class="col-md-3 text-right">Bloqueado</th>
                {% if object.blocked %}
                    <td><span class="glyphicon glyphicon-ok-sign" style="color: #44AD41"></span></td>
                {% else %}
                    <td><span class="glyphicon glyphicon-minus-sign" style="color: #DE2121"></span></td>
                {% endif %}
            </tr>

            {% if object.address %}
                <tr>
                    <th class="col-md-3 text-right">Endereço</th>
                    <td>{{ object.address }}</td>
                </tr>
            {% endif %}
            {% if object.complement %}
                <tr>
                    <th class="col-md-3 text-right">Complemento</th>
                    <td>{{ object.complement }}</td>
                </tr>
            {% endif %}
            {% if object.district %}
                <tr>
                    <th class="col-md-3 text-right">Bairro</th>
                    <td>{{ object.district }}</td>
                </tr>
            {% endif %}
            {% if object.city %}
                <tr>
                    <th class="col-md-3 text-right">Cidade</th>
                    <td>{{ object.city }}</td>
                </tr>
            {% endif %}
            {% if object.uf %}
                <tr>
                    <th class="col-md-3 text-right">UF</th>
                    <td>{{ object.uf }}</td>
                </tr>
            {% endif %}
            {% if object.cep %}
                <tr>
                    <th class="col-md-3 text-right">CEP</th>
                    <td>{{ object.cep }}</td>
                </tr>
            {% endif %}

        </tbody>
    </table>
</div>

{% endblock content %}
EOF


echo "${green}>>> Editing person_form.html${reset}"

cat << 'EOF' > $PROJECT/core/templates/core/person_form.html

EOF



# Person List
# Person Detail
# Person Form
# Person Admin
# API REST
# Tests with Selenium
# Fixtures with Generate Random Values
# New commands with django-admin
# Gráficos