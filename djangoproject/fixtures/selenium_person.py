import random
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from gen_names import gen_male_first_name, gen_female_first_name, gen_last_name
from gen_random_values import gen_doc, gen_timestamp, gen_phone

ffox = webdriver.Firefox()
ffox.get('http://localhost:8000/person/add/')

g = random.randint(0, 1)

if g:
    gender = 'id_gender_1'
    treatment = gen_female_first_name()['treatment']
    first_name = gen_female_first_name()['first_name']
else:
    gender = 'id_gender_0'
    treatment = gen_male_first_name()['treatment']
    first_name = gen_male_first_name()['first_name']

last_name = gen_last_name()

email = '{}.{}@example.com'.format(first_name[0].lower(), last_name.lower())

find_field = ffox.find_element_by_id(gender)
find_field.click()

find_field = ffox.find_element_by_id('id_treatment')
find_field.send_keys(treatment)

find_field = ffox.find_element_by_id('id_first_name')
find_field.send_keys(first_name)

find_field = ffox.find_element_by_id('id_last_name')
find_field.send_keys(last_name)

find_field = ffox.find_element_by_id('id_cpf')
find_field.send_keys(gen_doc())

find_field = ffox.find_element_by_id('id_birthday')
find_field.send_keys(gen_timestamp())

find_field = ffox.find_element_by_id('id_email')
find_field.send_keys(email)

find_field = ffox.find_element_by_id('id_phone')
find_field.send_keys(gen_phone())

button = ffox.find_element_by_id('id_submit')
button.click()
