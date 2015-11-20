#!/usr/bin/env ruby

## based on nginx-metrics
## https://github.com/sensu/sensu-community-plugins/blob/master/plugins/nginx/nginx-metrics.rb
##
##   golang-metrics
##
## DESCRIPTION:
##   Pull golang metrics for backends through stub status module
##
## OUTPUT:
##   metric data
##
## PLATFORMS:
##   Linux
##
## DEPENDENCIES:
##   gem: sensu-plugin
##
## USAGE:
##   #YELLOW
##
## NOTES:
##
## LICENSE:
##   Released under the same terms as Sensu (the MIT license); see LICENSE
##   for details.
##

require 'sensu-plugin/metric/cli'
require 'net/https'
require 'uri'
require 'socket'
require 'pp'

class GolangMetrics < Sensu::Plugin::Metric::CLI::Graphite
  option :url,
         short: '-u URL',
         long: '--url URL',
         description: 'Full URL to golang status page, example: https://yoursite.com/golang_status This ignores ALL other options EXCEPT --scheme'

  option :hostname,
         short: '-h HOSTNAME',
         long: '--host HOSTNAME',
         description: 'Golang hostname'

  option :port,
         short: '-P PORT',
         long: '--port PORT',
         description: 'Golang  port',
         default: '80'

  option :path,
         short: '-q STATUSPATH',
         long: '--statspath STATUSPATH',
         description: 'Path to your stub status module',
         default: '__status'

  option :scheme,
         description: 'Metric naming scheme, text to prepend to metric',
         short: '-s SCHEME',
         long: '--scheme SCHEME',
         default: "#{Socket.gethostname}.golang"



  def run
    found = false
    attempts = 0
    until found || attempts >= 10
      attempts += 1
      if config[:url]
        uri = URI.parse(config[:url])
        http = Net::HTTP.new(uri.host, uri.port)
        if uri.scheme == 'https'
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)
        if response.code == '200'
          found = true
        elsif !response.header['location'].nil?
          config[:url] = response.header['location']
        end
      else
        response = Net::HTTP.start(config[:hostname], config[:port]) do |connection|
          request = Net::HTTP::Get.new("/#{config[:path]}")
          connection.request(request)
        end
      end
    end


    response.body.split(/\r?\n/).each do |line|
      if line.match(/^num_goroutine\s+(\d+)/)
        num_goroutine = line.match(/^num_goroutine\s+(\d+)/).to_a[1]
        output "#{config[:scheme]}.num_goroutine", num_goroutine
      end
      if line.match(/^memory\s+(\d+)/)
        memory = line.match(/^memory\s+(\d+)/).to_a[1]
        output "#{config[:scheme]}.memory",memory
      end
    end
    ok
  en
end
