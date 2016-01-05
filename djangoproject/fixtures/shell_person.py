import random
import names
from myproject.core.models import Person
from fixtures.gen_names import gen_male_first_name, gen_female_first_name, gen_last_name
from fixtures.gen_random_values import gen_doc, gen_timestamp, gen_phone

REPEAT = 20

for i in range(REPEAT):
    g = random.choice(['M', 'F'])
    if g == 'M':
        treatment = gen_male_first_name()['treatment']
        first_name = gen_male_first_name()['first_name']
    else:
        treatment = gen_female_first_name()['treatment']
        first_name = gen_female_first_name()['first_name']
    last_name = names.get_last_name()
    birthday = gen_timestamp() + '+00'
    email = first_name[0].lower() + '.' + last_name.lower() + '@example.com'
    blocked = random.choice([1, 0])
    Person.objects.create(
        gender=g,
        treatment=treatment,
        first_name=first_name,
        last_name=last_name,
        cpf=gen_doc(),
        birthday=birthday,
        email=email,
        phone=gen_phone(),
        blocked=blocked,
    )

print('\n%d Persons salvo com sucesso.' % REPEAT)
