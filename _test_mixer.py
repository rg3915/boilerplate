from mixer.backend.django import mixer
from myproject.core.models import Person

person = mixer.blend(Person)
person.gender
person.treatment
person.first_name
person.last_name
person.cpf
person.birthday
person.email
person.phone
person.blocked

mixer.blend(Person).birthday


#-----------------------------------------
from mixer.backend.django import mixer
from myproject.core.models import Person

mixer = Mixer(locale='pt_br')
person = mixer.blend(Person)
person.first_name
person.last_name


person.faker.name()
# person.faker.gender()
# person.faker.treatment()
person.faker.first_name()
person.faker.last_name()
person.faker.cpf()
person.faker.date_time()
person.faker.iso8601()
person.faker.email()
person.faker.phone_number()
# person.faker.blocked()

#-----------------------------------------
from mixer.backend.django import Mixer
from myproject.core.models import Person

person = Mixer(locale='pt_br')
first_name = person.faker.first_name()
last_name = person.faker.last_name()
cpf = person.faker.cpf()
birthday = person.faker.iso8601()
email = person.faker.email()
phone = person.faker.phone_number()

mixer.blend(Person, first_name=first_name, last_name=last_name,
            cpf=cpf, birthday=birthday, email=email, phone=phone)
