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
