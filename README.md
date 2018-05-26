lan-yum-repo
1. download the rpm from the aliyun's mirror yum repo.
2. create the yum repo in the lan-network.

# build centos 7 base image for repo_generator
```
make build
```

# edit the package list.
```
vim /workdir/packages.txt
 jq  
 net-utils  
 docker  
 docker-compose  
```

# gen the repo for lan network yum repo
``` 
make clear
make gen 
```

# start network yum repo
```
make run
```

# download the .repo to the every host. 
```
curl -o /etc/yum.repos.d/wisecloud.repo http://${repo.lan.com}/wisecloud.repo
```

# install the packages which you want.
```
yum cleanall
yum makecache
yum --disablerepo=* --enablerepo=wisecloud -y install jq tree docker-compose
```