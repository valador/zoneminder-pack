THIS_FILE := $(lastword $(MAKEFILE_LIST))

.PHONY: help
help:
	make -pRrq -f $(THIS_FILE) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

.PHONY: patch-zm patch-zmes
patch-zm:
	patch -uN ./zm/Dockerfile ./patches/zm/Dockerfile-mlbase.diff || return 0 || return 1
patch-zmes:
	patch -uN ./zmes/Dockerfile ./patches/zmes/Dockerfile-mlapi.diff || return 1

.PHONY: build-zm build-zmes build-mlbase build-mlbase-cpu
build-zm: patch-zm
	DOCKER_BUILDKIT=1 docker build -t slayerus/zoneminder:1.36 --build-arg ZM_VERSION=1.36.5 --build-arg mlbase_version=cpu ./zm/.
	docker push slayerus/zoneminder:1.36
build-zmes: patch-zmes
	DOCKER_BUILDKIT=1 docker build -t slayerus/zoneminder-es:1.36 --build-arg ZM_VERSION=1.36 --build-arg ES_VERSION=v6.1.25 ./zmes/.
	docker push slayerus/zoneminder-es:1.36
build-mlbase:
	make -C ./mlbase
build-mlbase-cpu: build-mlbase
	docker build -t slayerus/mlbase:cpu --build-arg python_version=3.8 --build-arg opencv_version=4.5.3 --build-arg dlib_version=v19.22 ./mlbase/dist/cpu/.
	docker push slayerus/mlbase:cpu