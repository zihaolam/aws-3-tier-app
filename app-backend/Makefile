PYTHON=pipenv run python

all:
	pipenv requirements > requirements.txt
	docker build -t aws-localzone-3t-app-backend .