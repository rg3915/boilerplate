import string
from random import random, randrange, choice
from datetime import date, datetime, timedelta


def gen_cpf():
    def calcula_digito(digs):
        s = 0
        qtd = len(digs)
        for i in range(qtd):
            s += n[i] * (1 + qtd - i)
        res = 11 - s % 11
        if res >= 10:
            return 0
        return res
    n = [randrange(10) for i in range(9)]
    n.append(calcula_digito(n))
    n.append(calcula_digito(n))
    return "%d%d%d%d%d%d%d%d%d%d%d" % tuple(n)


def gen_digits(max_length):
    return str(''.join(choice(string.digits) for i in range(max_length)))


def gen_phone():
    # gera um telefone no formato xx xxxxx-xxxx
    digits_ = gen_digits(11)
    return '{} 9{}-{}'.format(digits_[:2], digits_[3:7], digits_[7:])


def gen_datetime(min_year=1900, max_year=datetime.now().year):
    # gera um datetime no formato yyyy-mm-dd hh:mm:ss.000000
    start = datetime(min_year, 1, 1)
    years = max_year - min_year + 1
    end = start + timedelta(days=365 * years)
    return (start + (end - start) * random()).isoformat(" ")


def gen_timestamp(min_year=1915, max_year=datetime.now().year):
    # gera um datetime no formato yyyy-mm-dd hh:mm:ss.000000
    min_date = datetime(min_year, 1, 1)
    max_date = datetime(max_year + 1, 1, 1)
    delta = random() * (max_date - min_date).total_seconds()
    return (min_date + timedelta(seconds=delta)).isoformat(" ")

# See more gen_random_values in
# https://gist.github.com/rg3915/744aacde209046901748
