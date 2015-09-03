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
sudo wget -O /etc/sensu/plugins/cpu-pcnt-usage-metrics.rb https://raw.githubusercontent.com/sensu/sensu-community-plugins/master/plugins/system/cpu-pcnt-usage-metrics.rb

# MEMORY
sudo wget -O /etc/sensu/plugins/memory-metrics-percent.rb https://raw.githubusercontent.com/sensu/sensu-community-plugins/master/plugins/system/memory-metrics-percent.rb
sudo wget -O /etc/sensu/plugins/memory-metrics.rb  https://raw.githubusercontent.com/sensu/sensu-community-plugins/master/plugins/system/memory-metrics.rb

# DISK
sudo wget -O /etc/sensu/plugins/disk-capacity-metrics.rb https://raw.githubusercontent.com/sensu/sensu-community-plugins/master/plugins/system/disk-capacity-metrics.rb

# IO
sudo wget -O /etc/sensu/plugins/iostat-extended-metrics.rb https://raw.githubusercontent.com/sensu/sensu-community-plugins/master/plugins/system/iostat-extended-metrics.rb

# Network
sudo wget -O /etc/sensu/plugins/metrics-netif.rb https://raw.githubusercontent.com/sensu-plugins/sensu-plugins-network-checks/master/bin/metrics-netif.rb
sudo wget -O /etc/sensu/plugins/metrics-netstat-tcp.rb https://raw.githubusercontent.com/sensu/sensu-community-plugins/master/plugins/network/metrics-netstat-tcp.rb


# Load Average
sudo wget -O /etc/sensu/plugins/load-metrics.rb https://raw.githubusercontent.com/sensu/sensu-community-plugins/master/plugins/system/load-metrics.rb

# Nginx 
sudo wget -O /etc/sensu/plugins/metrics-nginx.rb https://raw.githubusercontent.com/sensu-plugins/sensu-plugins-nginx/master/bin/metrics-nginx.rb



# Mysql
yum install -y mysql-devel gcc
/opt/sensu/embedded/bin/gem install mysql2 inifile
# XXX very owan SPEC
cp ./assets/sensu/plugins/custom-mysql-metrics.rb /etc/sensu/plugins/custom-mysql-metrics.rb


# unicorn plugin
/opt/sensu/embedded/bin/gem install raindrops




sudo chmod 775 /etc/sensu/plugins/*
sudo chown -R sensu:sensu /etc/sensu
