FROM ubuntu:latest


RUN apt-get update
RUN apt-get -y install wget

#-----------------
# INSTALL RABBITMQ
#-----------------

# https://sensuapp.org/docs/0.20/install-rabbitmq


# Step #1: Install Erlang
# ----------------------


RUN wget http://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
RUN dpkg -i erlang-solutions_1.0_all.deb
RUN apt-get update
RUN apt-get -y install erlang

# Step #2: Install RabbitMQ
# ----------------------

RUN wget http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
RUN apt-key add rabbitmq-signing-key-public.asc
RUN echo "deb     http://www.rabbitmq.com/debian/ testing main" | tee /etc/apt/sources.list.d/rabbitmq.list
RUN apt-get update
RUN apt-get -y install rabbitmq-server


#-----------------
# Install Redis
#-----------------
# https://sensuapp.org/docs/0.20/install-redis
RUN apt-get -y install redis-server



#-----------------
# Install the Sensu Core Repository
#-----------------
# https://sensuapp.org/docs/0.20/install-repositories

RUN wget -q http://repos.sensuapp.org/apt/pubkey.gpg -O- | apt-key add -
RUN echo "deb     http://repos.sensuapp.org/apt sensu main" | tee /etc/apt/sources.list.d/sensu.list

#-----------------
# Install Sensu
#-----------------
# https://sensuapp.org/docs/0.20/install-sensu

RUN apt-get update
RUN apt-get install sensu

# Configure Sensu
#-----------------
RUN wget -O /etc/sensu/config.json http://sensuapp.org/docs/0.20/files/config.json


# Configure a Check
#-----------------

RUN wget -O /etc/sensu/conf.d/check_memory.json http://sensuapp.org/docs/0.20/files/check_memory.json
RUN wget -O /etc/sensu/conf.d/default_handler.json http://sensuapp.org/docs/0.20/files/default_handler.json
RUN chown -R sensu:sensu /etc/sensu

# Install the Sensu client
#--------------------
RUN wget -O /etc/sensu/conf.d/client.json http://sensuapp.org/docs/0.20/files/client.json
RUN wget -O /etc/sensu/plugins/check-memory.sh http://sensuapp.org/docs/0.20/files/check-memory.sh
RUN chmod +x /etc/sensu/plugins/check-memory.sh


# Install Plugins
#--------------------

RUN apt-get install bc
RUN /opt/sensu/embedded/bin/gem install sys-filesystem

RUN wget -O /etc/sensu/plugins/check-cpu.sh https://raw.githubusercontent.com/sensu-plugins/sensu-plugins-cpu-checks/master/bin/check-cpu.sh
RUN wget -O /etc/sensu/plugins/check-disk-usage.rb https://raw.githubusercontent.com/sensu-plugins/sensu-plugins-disk-checks/master/bin/check-disk-usage.rb
RUN wget -O /etc/sensu/plugins/check-load.rb https://raw.githubusercontent.com/sensu-plugins/sensu-plugins-load-checks/master/bin/check-load.rb
RUN wget -O /etc/sensu/plugins/check-memory.sh https://raw.githubusercontent.com/sensu-plugins/sensu-plugins-memory-checks/master/bin/check-memory.sh


#--

RUN wget -O /etc/sensu/plugins/cpu-pcnt-usage-metrics.rb https://raw.githubusercontent.com/sensu/sensu-community-plugins/master/plugins/system/cpu-pcnt-usage-metrics.rb
RUN wget -O /etc/sensu/plugins/load-metrics.rb https://raw.githubusercontent.com/sensu/sensu-community-plugins/master/plugins/system/load-metrics.rb
RUN wget -O /etc/sensu/plugins/memory-metrics-percent.rb https://raw.githubusercontent.com/sensu/sensu-community-plugins/master/plugins/system/memory-metrics-percent.rb
RUN wget -O /etc/sensu/plugins/disk-capacity-metrics.rb https://raw.githubusercontent.com/sensu/sensu-community-plugins/master/plugins/system/disk-capacity-metrics.rb
RUN wget -O /etc/sensu/plugins/iostat-extended-metrics.rb https://raw.githubusercontent.com/sensu/sensu-community-plugins/master/plugins/system/iostat-extended-metrics.rb
RUN wget -O /etc/sensu/plugins/netif-metrics.rb https://raw.githubusercontent.com/sensu/sensu-community-plugins/master/plugins/network/netif-metrics.rb
RUN wget -O /etc/sensu/plugins/metrics-netstat-tcp.rb https://raw.githubusercontent.com/sensu/sensu-community-plugins/master/plugins/network/metrics-netstat-tcp.rb
RUN wget -O /etc/sensu/plugins/proc-status-metrics.rb https://raw.githubusercontent.com/sensu/sensu-community-plugins/master/plugins/system/proc-status-metrics.rb



# metrics-cloudwatch.rb


RUN wget -O /etc/sensu/mutators/graphite.rb https://raw.githubusercontent.com/sensu/sensu-community-plugins/master/mutators/graphite.rb




# MQ,API port
EXPOSE 5672 4567



RUN chmod 775 /etc/sensu/plugins/*
RUN chown -R sensu:sensu /etc/sensu

RUN apt-get install -y vim sysstat


# MQ,API port
EXPOSE 5672 4567

COPY assets /app/assets
RUN chmod 755 /app/assets/entrypoint.sh
ENTRYPOINT ["/app/assets/entrypoint.sh"]
