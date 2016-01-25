import time
from random import randint
from datetime import date, datetime, timedelta
from gen_names import gen_male_first_name, gen_female_first_name, gen_last_name
from gen_random_values import gen_cpf, gen_datetime, gen_phone
from selenium import webdriver
from selenium.webdriver.common.keys import Keys

page = webdriver.Firefox()
page.maximize_window()
time.sleep(0.5)
page.get('http://localhost:8000/person/add/')

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
print(treatment)
email = '{}.{}@example.com'.format(first_name[0].lower(), last_name.lower())

find_field = page.find_element_by_id(gender)
find_field.click()

fields = [
    ['id_treatment', treatment],
    ['id_first_name', first_name],
    ['id_last_name', last_name],
    ['id_cpf', gen_cpf()],
    ['id_birthday', gen_datetime()],
    ['id_email', email],
    ['id_phone', gen_phone()],
]

for field in fields:
    find_field = page.find_element_by_id(field[0])
    find_field.send_keys(field[1])

# button = page.find_element_by_id('id_submit')
button = page.find_element_by_class_name('btn-primary')
button.click()

page.quit()
