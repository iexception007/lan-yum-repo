REPO=wisecloud/repo_gen
VERSION=v0.1
INSTANCE_NAME=lan_repo
HOST_IP=$(shell netstat -rn | grep -E "^default|^0.0.0.0" | head -1 | awk '{print $$NF}' | xargs ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*'| cut -d " " -f 2)
    

build:
	docker build -t $(REPO):$(VERSION) .

gen:
	-docker rm -f repo_gen
	echo ${HOST_IP}
	docker run -d --name repo_gen -v ${PWD}/workdir:/workdir $(REPO):$(VERSION) /workdir/run.sh ${HOST_IP}
	docker logs -f repo_gen

run:
	-docker rm -f ${INSTANCE_NAME}
	docker run -p 80:80 --name ${INSTANCE_NAME} -d --privileged=true -v ${PWD}/workdir/wisecloud:/usr/share/nginx/html nginx:alpine
	docker cp config/nginx.conf ${INSTANCE_NAME}:/etc/nginx/nginx.conf
	docker cp config/default.conf ${INSTANCE_NAME}:/etc/nginx/conf.d/default.conf
	docker restart ${INSTANCE_NAME}
	docker logs -f ${INSTANCE_NAME}

clear:
	rm -rf ./workdir/wisecloud