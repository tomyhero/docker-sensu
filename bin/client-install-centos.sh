#!/bin/bash

set -e 

echo '[sensu]
name=sensu
baseurl=http://repos.sensuapp.org/yum/el/$basearch/
gpgcheck=0
enabled=1' | sudo tee /etc/yum.repos.d/sensu.repo

sudo yum install -y sensu sysstat

sudo /opt/sensu/embedded/bin/gem install sys-filesystem


sudo wget -O /etc/sensu/plugins/check-cpu.sh https://raw.githubusercontent.com/sensu-plugins/sensu-plugins-cpu-checks/master/bin/check-cpu.sh
sudo wget -O /etc/sensu/plugins/check-disk-usage.rb https://raw.githubusercontent.com/sensu-plugins/sensu-plugins-disk-checks/master/bin/check-disk-usage.rb
sudo wget -O /etc/sensu/plugins/check-load.rb https://raw.githubusercontent.com/sensu-plugins/sensu-plugins-load-checks/master/bin/check-load.rb
sudo wget -O /etc/sensu/plugins/check-memory.sh https://raw.githubusercontent.com/sensu-plugins/sensu-plugins-memory-checks/master/bin/check-memory.sh

# CPU
sudo wget -O /etc/sensu/plugins/cpu-pcnt-usage-metrics.rb https://raw.githubusercontent.com/sensu-plugins/sensu-plugins-cpu-checks/master/bin/metrics-cpu-pcnt-usage.rb

# MEMORY
sudo wget -O /etc/sensu/plugins/memory-metrics-percent.rb https://raw.githubusercontent.com/sensu-plugins/sensu-plugins-memory-checks/master/bin/metrics-memory-percent.rb
sudo wget -O /etc/sensu/plugins/memory-metrics.rb https://raw.githubusercontent.com/sensu-plugins/sensu-plugins-memory-checks/master/bin/metrics-memory.rb

# DISK
#sudo wget -O /etc/sensu/plugins/disk-capacity-metrics.rb https://raw.githubusercontent.com/sensu-plugins/sensu-plugins-disk-checks/master/bin/metrics-disk-capacity.rb
cp ./assets/sensu/plugins/disk-capacity-metrics.rb /etc/sensu/plugins/disk-capacity-metrics.rb

# IO
sudo wget -O /etc/sensu/plugins/iostat-extended-metrics.rb https://raw.githubusercontent.com/sensu-plugins/sensu-plugins-io-checks/master/bin/metrics-iostat-extended.rb

# Network
sudo wget -O /etc/sensu/plugins/metrics-netif.rb https://raw.githubusercontent.com/sensu-plugins/sensu-plugins-network-checks/master/bin/metrics-netif.rb
sudo wget -O /etc/sensu/plugins/metrics-netstat-tcp.rb https://raw.githubusercontent.com/sensu-plugins/sensu-plugins-network-checks/master/bin/metrics-netstat-tcp.rb


# Load Average
sudo wget -O /etc/sensu/plugins/load-metrics.rb https://raw.githubusercontent.com/sensu-plugins/sensu-plugins-load-checks/master/bin/metrics-load.rb

# Nginx 
sudo wget -O /etc/sensu/plugins/metrics-nginx.rb https://raw.githubusercontent.com/sensu-plugins/sensu-plugins-nginx/master/bin/metrics-nginx.rb



# Mysql
yum install -y mysql-devel gcc
/opt/sensu/embedded/bin/gem install mysql2 inifile
# XXX very owan SPEC
cp ./assets/sensu/plugins/custom-mysql-metrics.rb /etc/sensu/plugins/custom-mysql-metrics.rb


# unicorn plugin
/opt/sensu/embedded/bin/gem install raindrops


# postfix
sudo wget -O /etc/sensu/plugins/check-mail-delay.rb https://raw.githubusercontent.com/sensu-plugins/sensu-plugins-postfix/master/bin/check-mail-delay.rb
sudo wget -O /etc/sensu/plugins/metrics-mailq.rb  https://raw.githubusercontent.com/sensu-plugins/sensu-plugins-postfix/master/bin/metrics-mailq.rb

# apache
sudo wget -O /etc/sensu/plugins/metrics-apache-graphite.rb https://raw.githubusercontent.com/sensu-plugins/sensu-plugins-apache/master/bin/metrics-apache-graphite.rb



sudo chmod 775 /etc/sensu/plugins/*
sudo chown -R sensu:sensu /etc/sensu
