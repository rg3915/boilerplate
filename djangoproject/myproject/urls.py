from django.conf.urls import url
from django.contrib import admin
import myproject.core.views as v

urlpatterns = [
    url(r'^$', v.home, name='home'),
    url(r'^person/$', v.PersonList.as_view(), name='person_list'),
    url(r'^person/(?P<pk>\d+)/$', v.PersonDetail.as_view(), name='person_detail'),
    url(r'^person/edit/(?P<pk>\d+)/$',
        v.PersonUpdate.as_view(), name='person_edit'),
    url(r'^person/add/$', v.PersonCreate.as_view(), name='person_add'),
    url(r'^admin/', admin.site.urls),
]
