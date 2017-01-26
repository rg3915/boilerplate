import time
from random import randint
from decouple import config
from gen_address_ import address, district, city, state_name, complement
from gen_names_ import gen_male_first_name, gen_female_first_name, gen_last_name
from gen_random_values_ import gen_digits, gen_cpf, gen_date, convert_date
from selenium import webdriver


HOME = config('HOME')
# page = webdriver.Firefox()
page = webdriver.Chrome(executable_path=HOME + '/chromedriver/chromedriver')
page.maximize_window()
time.sleep(0.5)
page.get('http://localhost:8000/person/add/')

INDEX = randint(0, 146)

g = randint(0, 1)

if g:
    gender = 'id_gender_1'
    dict_ = gen_female_first_name()
else:
    gender = 'id_gender_0'
    dict_ = gen_male_first_name()

treatment = dict_['treatment']
first_name = dict_['first_name']
last_name = gen_last_name()
print(first_name, last_name)

email = '{}.{}@example.com'.format(first_name[0].lower(), last_name.lower())

slug = '{}-{}'.format(first_name.lower(), last_name.lower())

cep = '{}-{}'.format(gen_digits(5), gen_digits(3))

complement = '{} {}'.format(complement(), gen_digits(2))

photo = 'http://icons.iconarchive.com/icons/icons-land/vista-people/256/Office-Customer-Male-Light-icon.png'

search = page.find_element_by_id(gender)
search.click()

fields = [
    ['id_treatment', treatment],
    ['id_first_name', first_name],
    ['id_last_name', last_name],
    ['id_slug', slug],
    ['id_email', email],
    ['id_cpf', gen_cpf()],
    ['id_address', address()],
    ['id_complement', complement],
    ['id_district', district()],
    ['id_city', city()],
    ['id_uf', state_name()],
    ['id_cep', cep],
    ['id_birthday', convert_date(gen_date())],
]

for field in fields:
    search = page.find_element_by_id(field[0])
    search.send_keys(field[1])
    time.sleep(0.2)


# button = page.find_element_by_id('id_submit')
button = page.find_element_by_class_name('btn-primary')
# button.click()

# page.quit()
