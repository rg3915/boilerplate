migrate:
	python manage.py makemigrations
	python manage.py migrate

selenium_person:
	python fixtures/selenium_person.py

shell_person:
	python manage.py shell < fixtures/shell_person.py

backup:
	python manage.py dumpdata --format=json --indent=2 > fixtures.json

load:
	python manage.py loaddata fixtures.json

run:
	python manage.py runserver