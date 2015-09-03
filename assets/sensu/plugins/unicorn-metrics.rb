#! /usr/bin/env ruby


# /etc/sensu/unicorn-metrics.json
#{
#       "entries" : [
#       {
#               "name" : "web",
#               "socket" : "/home/foo/bar/tmp/sockets/unicorn.sock"
#       }
#       ]
#}


require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-plugin/metric/cli'
require 'raindrops'
require 'json'

class UnicornMetrics < Sensu::Plugin::Metric::CLI::Graphite


def run

json = JSON.parse( File.read("/etc/sensu/unicorn-metrics.json") )

json["entries"].each{|item|
	stats = Raindrops::Linux.unix_listener_stats([item["socket"]])[item["socket"]]
		output "#{item["name"]}.active", stats.active
		output "#{item["name"]}.queued", stats.queued
}

ok
end

end
