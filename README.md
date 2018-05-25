# lan-yum-repo
yum source at the lan network

# make local source
``` bash
./makelocalrepo.sh localrepo jq tree docker-py docker-compose  
```
<---  
```
localrepo
localrepo.tar.gz
```

# use local source
tar -zxvf localrepo.tar.gz
cd localrepo
./install.sh


# docker nginx
make run

# copy wisecloud.repo to every host.
cp wisecloud.repo /etc/yum.repos.d/wisecloud.repo
yum cleanall
yum makecache
yum --disablerepo=* --enablerepo=wisecloud -y install jq tree docker-compose