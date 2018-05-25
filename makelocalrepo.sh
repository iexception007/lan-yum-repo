#!/bin/bash
#
# makelocalrepo.sh - Make local minimal yum repository
#
set -eu

[[ $# > 1 ]] || {
  echo "$(basename $0) dest package..."
  echo "  \$ ./$(basename $0) localrepo jq tree"
  echo "  dest:    Name of local repository to create. dest.tar.gz is created."
  echo "  package: Name of yum package to include into dest."
  exit 1
}

dest=${1%.tar.gz}
[[ ! -e "$dest" ]] || {
  echo "$dest should not exist."
  exit 1
}

shift
packages=$*
repo="$dest/repo"

echo "dest=$dest"
echo "packages=$packages"
echo "repo=$repo"

rpm -q --quiet yum-utils || yum install -y yum-utils
mkdir -p $repo
yumdownloader --resolve --destdir=$repo $packages
rpm -q --quiet createrepo || yum install -y createrepo
createrepo $repo


cat > "$dest/install.sh" <<EOS
#!/bin/bash
set -eu

cat > /etc/yum.repos.d/localrepo.repo <<EOF
[localrepo]
name=localrepo
baseurl=file://\$(readlink -f \$(dirname "\$0"))/repo
enabled=0
gpgcheck=0
EOF

yum --disablerepo=* --enablerepo=localrepo -y install $packages
EOS

cat > "$dest/remove.sh" <<EOS
yum -y remove $packages
EOS

chmod +x "$dest/install.sh"
chmod +x "$dest/remove.sh"

tar czf "$dest.tar.gz" "$dest"
