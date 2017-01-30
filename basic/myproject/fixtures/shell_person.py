import random
import names
from myproject.core.models import Person, Phone
from myproject.selenium.gen_address import address, district, city, state_uf, complement
from myproject.selenium.gen_names import gen_male_first_name, gen_female_first_name, gen_last_name
from myproject.selenium.gen_random_values import gen_digits, gen_cpf, gen_timestamp, gen_phone


PHONE_TYPE = ('pri', 'com', 'res', 'cel')
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
    email = '{}.{}@example.com'.format(
        first_name[0].lower(), last_name.lower())
    slug = '{}-{}'.format(first_name[0].lower(), last_name.lower())
    birthday = gen_timestamp() + '+00'
    blocked = random.choice([1, 0])
    cep = '{}-{}'.format(gen_digits(5), gen_digits(3))
    complement_ = '{} {}'.format(complement(), gen_digits(2))
    Person.objects.create(
        gender=g,
        treatment=treatment,
        first_name=first_name,
        last_name=last_name,
        slug=slug,
        cpf=gen_cpf(),
        birthday=birthday,
        email=email,
        address=address(),
        complement=complement_,
        district=district(),
        city=city(),
        uf=state_uf(),
        cep=cep,
        blocked=blocked,
    )


''' Insert Phones '''
persons = Person.objects.all()
for person in persons:
    for i in range(1, random.randint(1, 5)):
        Phone.objects.create(
            person=person,
            phone=gen_phone(),
            phone_type=random.choice(PHONE_TYPE))


print('\n%d Persons salvo com sucesso.' % REPEAT)
