from django.db import models
from django.core.urlresolvers import reverse_lazy
from django.shortcuts import resolve_url as r
from localflavor.br.br_states import STATE_CHOICES
# List of values for use in choices
from .lists import GENDER_LIST, TREATMENT_LIST, PHONE_TYPE


class TimeStampedModel(models.Model):
    created = models.DateTimeField(auto_now_add=True, auto_now=False)
    modified = models.DateTimeField(auto_now_add=False, auto_now=True)

    class Meta:
        abstract = True


class Address(models.Model):
    address = models.CharField(max_length=100, blank=True)
    complement = models.CharField(max_length=100, blank=True)
    district = models.CharField(max_length=100, blank=True)
    city = models.CharField(max_length=100, blank=True)
    uf = models.CharField('UF', max_length=2,
                          choices=STATE_CHOICES, blank=True)
    cep = models.CharField('CEP', max_length=9, blank=True)

    class Meta:
        abstract = True


class Person(TimeStampedModel, Address):
    gender = models.CharField(max_length=1, choices=GENDER_LIST)
    treatment = models.CharField(
        max_length=4, choices=TREATMENT_LIST, default='')
    first_name = models.CharField('first name', max_length=30)
    last_name = models.CharField('last name', max_length=30)
    cpf = models.CharField('CPF', max_length=11, unique=True, blank=True)
    birthday = models.DateTimeField(null=True, blank=True)
    email = models.EmailField(blank=True)
    blocked = models.BooleanField(default=False)

    class Meta:
        ordering = ['first_name']
        verbose_name = 'contact'
        verbose_name_plural = 'contacts'

    def __str__(self):
        return ' '.join(filter(None, [self.get_treatment_display(), self.first_name, self.last_name]))

    full_name = property(__str__)

    def get_absolute_url(self):
        ''' return id '''
        return reverse_lazy('core:person_detail', kwargs={'pk': self.pk})


class Phone(models.Model):
    phone = models.CharField(max_length=20, blank=True)
    person = models.ForeignKey('Person')
    phone_type = models.CharField(
        max_length=3, choices=PHONE_TYPE, default='pri')

    def __str__(self):
        return self.phone
