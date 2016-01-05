from django.db import models
from django.core.urlresolvers import reverse_lazy
# List of values for use in choices
from .lists import gender_list, treatment_list


class TimeStampedModel(models.Model):
    created = models.DateTimeField(auto_now_add=True, auto_now=False)
    modified = models.DateTimeField(auto_now_add=False, auto_now=True)

    class Meta:
        abstract = True


class Person(TimeStampedModel):
    gender = models.CharField(max_length=1, choices=gender_list)
    treatment = models.CharField(
        max_length=4, choices=treatment_list, default='')
    first_name = models.CharField('first name', max_length=30)
    last_name = models.CharField('last name', max_length=30)
    cpf = models.CharField('CPF', max_length=11, unique=True)
    birthday = models.DateTimeField(null=True, blank=True)
    email = models.EmailField(blank=True)
    phone = models.CharField(max_length=20, default='')
    blocked = models.BooleanField(default=False)

    class Meta:
        ordering = ['first_name']
        verbose_name = 'contact'
        verbose_name_plural = 'contacts'

    def __str__(self):
        return "{} {} {}".format(self.get_treatment_display(), self.first_name, self.last_name)

    full_name = property(__str__)

    def get_absolute_url(self):
        ''' return id '''
        return reverse_lazy('person_detail', kwargs={'pk': self.pk})
