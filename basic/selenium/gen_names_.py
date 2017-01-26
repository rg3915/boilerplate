import random
import names

""" List of values for use in choices in models. """
treatment_male_list = ('Arq', 'Dr', 'Eng', 'Prof', 'Sr',)

treatment_female_list = ('Arqa', 'Dona', 'Engª', 'Profa', 'Sra', 'Srta',)


def gen_male_first_name():
    treatment = random.choice(treatment_male_list)
    first_name = names.get_first_name(gender='male')
    c = {'treatment': treatment, 'first_name': first_name}
    return c


def gen_female_first_name():
    treatment = random.choice(treatment_female_list)
    first_name = names.get_first_name(gender='female')
    c = {'treatment': treatment, 'first_name': first_name}
    return c


def gen_last_name():
    return names.get_last_name()
