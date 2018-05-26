#!/usr/bin/env bash


function read_packages_file() {
    packages_file=$1
    list=$(cat $1 | tr "\n" " " | awk 'gsub(/^ *| *$/,"")')
    # array=($list)
    # for tool in ${array[*]}; do
    #     echo $tool
    # done
    echo $list
}

HOST_IP=$1
repo="wisecloud/repo"
packages=`read_packages_file ./packages.txt`
rm -rf wisecloud
mkdir -p $repo

cat > wisecloud/index.html <<EOF
<html>
    <head>
        <title>wisecloud yum repo</title>
    </head>
    <body>
        <H1>wisecloud yum repo source</H1>
        <H1 style="color:red"><a href="/repo" >/repo</a></H1>
        
        <hr>

        <H2 style="color:red">the packages list of the repo:</H2>
        <H3>
            $packages
        </H3>
        <hr>
        
        <H2 style="color:red">make the wisecloud.repo</H2>
        <H3 style="color:blue">
        [wisecloud]<br>
        name=wisecloud<br>
        baseurl=http://${HOST_IP}/repo<br>
        enabled=1<br>
        gpgcheck=0<br>
        </H3>
        
        <hr>

        <H2 style="color:red">install the packages with the wisecloud.repo</H2>
        <H3 style="color:black">
        <p>
        curl -o /etc/yum.repos.d/wisecloud.repo http://${HOST_IP}/wisecloud.repo<br>
        yum cleanall<br>
        yum makecache<br>
        yum --disablerepo=* --enablerepo=wisecloud -y install jq tree docker-compose<br>
        </p>
        </H3>
    </body>
</html>
EOF

cat > wisecloud/wisecloud.repo <<EOF
[wisecloud]
name=wisecloud
baseurl=http://${HOST_IP}/repo
enabled=1
gpgcheck=0
EOF

echo "downloading to $repo packages: $packages"

rpm -q --quiet yum-utils 
if [[ $? -ne 0 ]]; then
    echo "no install yum-utils"
    exit 2
fi

yumdownloader --resolve --destdir=$repo $packages
if [[ $? -ne 0 ]]; then
    echo "download packages failed."
    exit 2
fi

rpm -q --quiet createrepo 
if [[ $? -ne 0 ]]; then
    echo "no install createrepo"
    exit 2
fi

createrepo $repo
if [[ $? -ne 0 ]]; then
    echo "createrepo is failed."
    exit 2
fi


