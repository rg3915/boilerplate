from django import forms
from .models import Person

gender_list = [('M', 'male'), ('F', 'female')]


class PersonForm(forms.ModelForm):
    gender = forms.ChoiceField(
        choices=gender_list, initial='M', widget=forms.RadioSelect)

    class Meta:
        model = Person
        fields = ['gender', 'treatment', 'first_name', 'last_name', 'email', 'cpf', 'address',
                  'complement', 'district', 'city', 'uf', 'cep', 'birthday', 'blocked']

    def clean_cpf(self):
        return self.cleaned_data['cpf'] or ''
