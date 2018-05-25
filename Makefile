INSTANCE_NAME=my-nginx

run:
	-docker rm -f ${INSTANCE_NAME}
	docker run -p 80:80 --name ${INSTANCE_NAME} -d --privileged=true -v ${PWD}/localrepo:/usr/share/nginx/html nginx:alpine
	docker cp nginx.conf ${INSTANCE_NAME}:/etc/nginx/nginx.conf
	docker cp default.conf ${INSTANCE_NAME}:/etc/nginx/conf.d/default.conf
	docker restart ${INSTANCE_NAME}
	docker logs -f ${INSTANCE_NAME}


test:
	cp wisecloud.repo /etc/yum.repos.d/wisecloud.repo
	yum clean all
	yum makecache
	yum --disablerepo=* --enablerepo=wisecloud -y install jq tree
