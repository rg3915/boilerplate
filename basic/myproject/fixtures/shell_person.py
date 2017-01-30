import random
import names
from myproject.core.models import Person, Phone
from myproject.selenium.gen_address import address, district, city, state_uf, complement
from myproject.selenium.gen_names import gen_male_first_name, gen_female_first_name, gen_last_name
from myproject.selenium.gen_random_values import gen_digits, gen_cpf, gen_timestamp, gen_phone


PHONE_TYPE = ('pri', 'com', 'res', 'cel')
person_list = []
phone_list = []
REPEAT = 20


def person_data():
    gender = random.choice(['M', 'F'])
    if gender == 'M':
        treatment = gen_male_first_name()['treatment']
        first_name = gen_male_first_name()['first_name']
    else:
        treatment = gen_female_first_name()['treatment']
        first_name = gen_female_first_name()['first_name']
    last_name = names.get_last_name()
    slug = '{}-{}'.format(first_name.lower(), last_name.lower())
    email = slug + '@example.com'
    birthday = gen_timestamp() + '+00'
    blocked = random.choice([1, 0])
    cep = '{}-{}'.format(gen_digits(5), gen_digits(3))
    complement_ = '{} {}'.format(complement(), gen_digits(2))
    return {'gender': gender,
            'treatment': treatment,
            'first_name': first_name,
            'last_name': last_name,
            'slug': slug,
            'cpf': gen_cpf(),
            'birthday': birthday,
            'email': email,
            'address': address(),
            'complement': complement_,
            'district': district(),
            'city': city(),
            'uf': state_uf(),
            'cep': cep,
            'blocked': blocked,
            }


# Appending person_list
for _ in range(REPEAT):
    person_list.append(person_data())

# Insert Persons
obj = [Person(**person) for person in person_list]
Person.objects.bulk_create(obj)

# Appending phone_list
persons = Person.objects.all()
for person in persons:
    for _ in range(1, random.randint(2, 5)):
        phone_list.append({
            'person': person,
            'phone': gen_phone(),
            'phone_type': random.choice(PHONE_TYPE),
        })

# Insert Phones
obj = [Phone(**phone) for phone in phone_list]
Phone.objects.bulk_create(obj)

print('\n%d Persons salvo com sucesso.' % REPEAT)
