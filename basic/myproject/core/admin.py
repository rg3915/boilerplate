from daterange_filter.filter import DateRangeFilter
from django.contrib import admin
from .models import Person


class PersonAdmin(admin.ModelAdmin):
    list_display = ('__str__', 'gender', 'email',
                    'phone', 'cpf', 'birthday', 'blocked')
    date_hierarchy = 'birthday'
    search_fields = ('first_name', 'last_name', 'cpf')
    list_filter = ('gender', ('created', DateRangeFilter),)


admin.site.register(Person, PersonAdmin)
