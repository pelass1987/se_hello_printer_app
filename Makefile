.PHONY: test

deps:
	pip install -r requirements.txt; \
	pip install -r test_requirements.txt

test:
	PYTHONPATH=. py.test  --verbose -s

run:
	python main.py

lint:
	flake8 hello_world/

docker_build:
	docker build -t hello-world-printer .

docker_run: docker_build
	docker run \
		--name hello-world-printer-dev \
		-p 5000:5000 \
		-d hello-world-printer

USERNAME=unobrevo
TAG=$(USERNAME)/hello-world-printer
docker_push: docker_build
		@docker login --username $(USERNAME) --password $${DOCKER_PASSWORD}; \
		docker tag hello-world-printer $(TAG); \
		docker push $(TAG); \
		language: python
		services:
		- docker
		python:
		- "2.7"
		install:
		- make deps
		script:
		- make test
		- make lint
		- make docker_build
		- make docker_push

test_smoke:
		curl --fail 127.0.0.1:5000
