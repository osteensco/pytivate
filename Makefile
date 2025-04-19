default: run

run:
	docker image inspect pytivate > /dev/null 2>&1 || docker build -t pytivate .
	docker run -it pytivate
i:
	docker image inspect pytivate > /dev/null 2>&1 || docker build -t pytivate .
	docker run -it pytivate /bin/bash

build:
	docker build -t pytivate .
