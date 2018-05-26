FROM centos:7
MAINTAINER zhouyi "6098550@qq.com"


RUN  mv /etc/yum.repos.d/CentOS-Base.repo      /etc/yum.repos.d/CentOS-Base.repo.backup     \
#  && mv /etc/yum.repos.d/epel.repo             /etc/yum.repos.d/epel.repo.backup            \
  && curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo \
  && curl -o /etc/yum.repos.d/epel.repo        http://mirrors.aliyun.com/repo/epel-7.repo   \
  && mkdir /workdir \
  && yum clean all  \
  && yum makecache  \
  && yum install -y yum-utils createrepo 

WORKDIR /workdir
CMD [ "/workdir/run.sh" ]
