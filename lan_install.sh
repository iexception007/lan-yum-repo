#!/usr/bin/env bash

yum cleanall
yum makecache
yum --disablerepo=* --enablerepo=wisecloud -y install jq tree docker-compose
