PYTHON=pipenv run python

all:
	pipenv requirements > requirements.txt
	docker build -t aws-localzone-3t-app-backend .


run:
	docker run -d -p 80:8030 aws-localzone-3t-app-backend