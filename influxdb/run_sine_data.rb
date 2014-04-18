#!/usr/bin/env ruby
require 'rubygems'
require 'influxdb'

influxdb = InfluxDB::Client.new(:host => "127.0.0.1")

database = 'test'
username = 'root'
password = 'root'

influxdb = InfluxDB::Client.new(database, :username => username, :password => password)

# Enumerator that emits a sine wave
value = (0..360).to_a.map {|i| Math.send(:sin, i / 10.0) * 10 }.each

puts "Writing one point every second - Please kill when you are done me because I won't stop"

loop do
  data = {
    :value => value.next
  }

  influxdb.write_point('sine', data)

  sleep 1
end
