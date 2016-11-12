from django.shortcuts import render
from django.http import HttpResponse
from django.core.urlresolvers import reverse_lazy
from django.db.models import Q
from django.views.generic import CreateView, TemplateView, ListView, DetailView
from django.views.generic.edit import UpdateView
from .models import Person
from .forms import PersonForm


def home(request):
    return render(request, 'index.html')


class CounterMixin(object):

    def get_context_data(self, **kwargs):
        context = super(CounterMixin, self).get_context_data(**kwargs)
        context['count'] = self.get_queryset().count()
        return context


class PersonList(CounterMixin, ListView):
    template_name = 'core/person_list.html'
    model = Person
    context_object_name = 'persons'
    paginate_by = 10

    def get_queryset(self):
        w = Person.objects.all()
        q = self.request.GET.get('search_box')
        if q is not None:
            w = w.filter(
                Q(first_name__icontains=q) |
                Q(last_name__icontains=q))
        return w


class PersonCreate(CreateView):
    template_name = 'core/person_form.html'
    form_class = PersonForm
    success_url = reverse_lazy('person_list')


class PersonDetail(DetailView):
    template_name = 'core/person_detail.html'
    model = Person


class PersonUpdate(UpdateView):
    template_name = 'core/person_form.html'
    model = Person
    form_class = PersonForm
    success_url = reverse_lazy('person_list')
