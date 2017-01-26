import names
from random import choice, randint


street_prefixes = ('Alameda', 'Avenida', 'Estrada',
                   'Largo', 'Praça', 'Rua', 'Travessa')


districts = ('Acaiaca', 'Aguas Claras', 'Alpes', 'Alto Barroca',
             'Alto Dos Pinheiros', 'Alto Vera Cruz', 'Anchieta', 'Bacurau',
             'Bandeirantes', 'Barreiro', 'Barroca', 'Belmonte', 'Bonfim',
             'Bonsucesso', 'Cachoeirinha', 'Caiçaras', 'Califórnia',
             'Diamante', 'Dom Joaquim', 'Embaúbas', 'Esplanada', 'Estrela',
             'Floramar', 'Floresta', 'Garças', 'Glória', 'Grajaú',
             'Horto Florestal', 'Indaiá', 'Ipe', 'Ipiranga', 'Itaipu',
             'Jaraguá', 'Jardim Alvorada', 'Jardinópolis', 'Jatobá',
             'Lagoa', 'Laranjeiras', 'Liberdade', 'Madri', 'Manacas',
             'Miramar', 'Nova America', 'Novo Tupi', 'Oeste', 'Pantanal',
             'Renascença', 'Santa Inês', 'Santa Sofia', 'Teixeira Dias',
             'Tiradentes', 'Urca', 'Vera Cruz', 'Vila Da Luz', 'Vila Pilar',
             'Vitoria', 'Xangri-Lá', 'Zilah Sposito', )

states = (
    ('AC', 'Acre'),
    ('AL', 'Alagoas'),
    ('AP', 'Amapá'),
    ('AM', 'Amazonas'),
    ('BA', 'Bahia'),
    ('CE', 'Ceará'),
    ('DF', 'Distrito Federal'),
    ('ES', 'Espírito Santo'),
    ('GO', 'Goiás'),
    ('MA', 'Maranhão'),
    ('MT', 'Mato Grosso'),
    ('MS', 'Mato Grosso do Sul'),
    ('MG', 'Minas Gerais'),
    ('PA', 'Pará'),
    ('PB', 'Paraíba'),
    ('PR', 'Paraná'),
    ('PE', 'Pernambuco'),
    ('PI', 'Piauí'),
    ('RJ', 'Rio de Janeiro'),
    ('RN', 'Rio Grande do Norte'),
    ('RS', 'Rio Grande do Sul'),
    ('RO', 'Rondônia'),
    ('RR', 'Roraima'),
    ('SC', 'Santa Catarina'),
    ('SP', 'São Paulo'),
    ('SE', 'Sergipe'),
    ('TO', 'Tocantins'))


complements = ('andar', 'apto', 'casa', 'fundos', 'loja')


def random_element(elements):
    return choice(elements)


def gen_first_name():
    return names.get_first_name()


def gen_last_name():
    return names.get_last_name()


def address():
    """
    :example 'Rua Eurides da Cunha, 116'
    """
    street_prefix = random_element(street_prefixes)
    first_name = gen_first_name()
    last_name = gen_last_name()
    gen_number = randint(1, 9999)
    pattern = '{} {} {}, {}'.format(
        street_prefix, first_name, last_name, gen_number)
    return pattern


def city():
    return gen_last_name()


def state():
    """
    Randomly returns a Brazilian State  ('sigla' , 'nome').
    :example ('MG' . 'Minas Gerais')
    """
    return random_element(states)


def state_name():
    """
    Randomly returns a Brazilian State Name
    :example 'Minas Gerais'
    """
    return state()[1]


def state_uf():
    """
    Randomly returns the abbreviation of a Brazilian State
    :example 'MG'
    """
    return state()[0]


def district():
    """
    Randomly returns a bairro (neighborhood) name. The names were taken from the city of Belo Horizonte - Minas Gerais
    :example 'Serra'
    """
    return random_element(districts)

# https://github.com/joke2k/faker/blob/master/faker/providers/__init__.py


def complement():
    return random_element(complements)
