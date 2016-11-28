install:
	pip install -r requirements.txt

createuser:
	./manage.py createsuperuser --username='admin' --email=''

clear:
	rm -rf myproject
	rm -rf __pycache__
	rm -f db.sqlite3
	rm -f .env
	rm -f manage.py
	rm -f requirements.txt