from django.conf.urls import include, url
from myproject.core import views as c

person_patterns = [
    url(r'^$', c.PersonList.as_view(), name='person_list'),
    url(r'^add/$', c.PersonCreate.as_view(), name='person_add'),
    url(r'^(?P<slug>[\w-]+)/$', c.person_detail, name='person_detail'),
    url(r'^(?P<slug>[\w-]+)/edit/$', c.person_update, name='person_edit'),
    url(r'^(?P<slug>[\w-]+)/delete/$', c.person_delete, name='person_delete'),
]

urlpatterns = [
    url(r'^$', c.home, name='home'),
    url(r'^person/', include(person_patterns)),
]
