from datetime import datetime
from django.shortcuts import resolve_url as r
from django.test import TestCase
from myproject.core.models import Person
from myproject.core.tests import PERSON_DATA


class PersonTest(TestCase):

    def setUp(self):
        self.obj = Person.objects.create(**PERSON_DATA)

    def test_create(self):
        self.assertTrue(Person.objects.exists())

    def test_created(self):
        ''' Person must have an auto created attr. '''
        self.assertIsInstance(self.obj.created, datetime)

    def test_str(self):
        self.assertEqual('Sr. Regis Santos', str(self.obj))

    def test_ordering(self):
        self.assertListEqual(['first_name'], Person._meta.ordering)

    def test_get_absolute_url(self):
        url = r('core:person_detail', slug=self.obj.slug)
        self.assertEqual(url, self.obj.get_absolute_url())
