# -*- coding: utf-8 -*-
# Generated by Django 1.10.5 on 2017-01-12 00:39
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0004_auto_20161128_1810'),
    ]

    operations = [
        migrations.AddField(
            model_name='person',
            name='slug',
            field=models.SlugField(blank=True, verbose_name='slug'),
        ),
    ]