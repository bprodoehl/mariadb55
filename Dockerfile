from    ubuntu:14.04

# Configure apt
run    echo 'deb http://us.archive.ubuntu.com/ubuntu/ trusty universe' >> /etc/apt/sources.list
run    apt-get -y update
run    apt-get -y install python-software-properties software-properties-common
run    apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
run    add-apt-repository 'deb http://ftp.osuosl.org/pub/mariadb/repo/5.5/ubuntu trusty main'
run     apt-key adv --recv-keys --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A

# Make apt and MariaDB happy with the docker environment
run    echo "#!/bin/sh\nexit 101" >/usr/sbin/policy-rc.d
run    chmod +x /usr/sbin/policy-rc.d

# /etc/mtab is a symlink to /proc/mounts on some systems
run    rm /etc/mtab && cat /proc/mounts >/etc/mtab

# Install MariaDB
run    apt-get -y update
run    apt-get -y install
run    LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y iproute mariadb-galera-server galera rsync netcat-openbsd socat pv

# this is for testing - can be commented out later
run    LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y iputils-ping net-tools

run    add-apt-repository 'deb http://repo.percona.com/apt trusty main'
run    apt-get -y update
run    LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y percona-xtrabackup

# Install Monit and Lua (for monit plugins)
run    LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y monit lua5.2 lua-sql-mysql lua-socket

# add in extra wsrep scripts
add     wsrep_sst_common /usr/bin/wsrep_sst_common
add     wsrep_sst_xtrabackup-v2 /usr/bin/wsrep_sst_xtrabackup-v2

# Clean up
run    rm /usr/sbin/policy-rc.d
run    rm -r /var/lib/mysql

# Add config(s) - standalong and cluster mode
add    ./my-cluster.cnf /etc/mysql/my-cluster.cnf
add    ./my-init.cnf /etc/mysql/my-init.cnf

add    ./mariadb-setrootpassword /usr/bin/mariadb-setrootpassword
add    ./mariadb-start /usr/bin/mariadb-start

add    ./generate-keys.sh /usr/bin/generate-keys.sh
add    ./openssl.cnf /etc/mysql/openssl.cnf

add    ./monit /usr/share/monit-mysql

expose    3306 4567 4444

cmd    ["/usr/bin/mariadb-start"]

# vim:ts=8:noet:
