#!/usr/bin/env ruby
require 'rubygems'
require 'influxdb'

influxdb = InfluxDB::Client.new(:host => "127.0.0.1")

database = 'test'
username = 'root'
password = 'root'

influxdb = InfluxDB::Client.new(database, :username => username, :password => password)

NODE_IDS = [ 2, 3, 4, 27, 28, 29 ]


puts
puts "= Count points"

series = influxdb.query("SELECT COUNT(node_id) FROM sensors;")
puts series


puts
puts "= First point"

series = influxdb.query("SELECT * FROM sensors LIMIT 1;")
puts series


puts
puts "= First temperature for the last 24 hours for node 2"

series = influxdb.query("SELECT FIRST(temperature) FROM sensors WHERE time > NOW() - 24h AND node_id=2;")
puts series


puts
puts "= Last temperature for the last 24 hours for node 2"

series = influxdb.query("SELECT LAST(temperature) FROM sensors WHERE time > NOW() - 24h AND node_id=2;")
puts series


puts
puts "= Count of temperature values in 5 minute periods for the last 4 hours for node 2"

series = influxdb.query("SELECT COUNT(temperature) FROM sensors GROUP BY time(5m) WHERE time > NOW() - 4h AND node_id=2;")
puts series


puts
puts "= Count of temperature values in 60 minutes periods for the last 24 hours for node 2"

series = influxdb.query("SELECT COUNT(temperature) FROM sensors GROUP BY time(60m) WHERE time > NOW() - 24h AND node_id=2;")
puts series


puts
puts "= Minimun temperature for node 2 for the last 24 hours"

series = influxdb.query("SELECT MIN(temperature) FROM sensors WHERE time > NOW() - 24h AND node_id=3;")
puts series


puts
puts "= Continous query: minimun temperature for node 2 every hour"

influxdb.query("SELECT MIN(temperature) FROM sensors WHERE node_id=3 GROUP BY time(1h) into temperature.min.1h;")

series = influxdb.query("SELECT * FROM temperature.min.1h;")
puts series


puts
puts "= Continous query: minimun temperature for node 2 every day"

influxdb.query("SELECT MIN(temperature) FROM sensors WHERE node_id=3 GROUP BY time(1d) into temperature.min.1d;")

series = influxdb.query("SELECT * FROM temperature.min.1d;")
puts series


puts
puts "= Maximum temperature for node 2 for the last 24 hours"

series = influxdb.query("SELECT MAX(temperature) FROM sensors WHERE time > NOW() - 24h AND node_id=2;")
puts series


# puts
# puts "= Continous query: maximum temperature for every hour"

# influxdb.query("SELECT MAX(temperature) FROM sensors GROUP BY time(1h) into temperature.max.1h;")

# NODE_IDS.each do |node_id|
#   influxdb.query("SELECT MAX(temperature) FROM sensors WHERE node_id=#{node_id} GROUP BY time(1h) into temperature.max.1h.node#{node_id};")
# end


# puts "== all nodes"
# series = influxdb.query("SELECT * FROM temperature.max.1h;")
# puts series

# NODE_IDS.each do |node_id|
#   puts "== node2"
#   series = influxdb.query("SELECT * FROM temperature.max.1h.node#{node_id};")
#   puts series
# end


puts
puts "= Continous query: maximum temperature every day"

influxdb.query("SELECT MAX(temperature) FROM sensors GROUP BY time(1d) into temperature.max.1d;")

NODE_IDS.each do |node_id|
  influxdb.query("SELECT MAX(temperature) FROM sensors WHERE node_id=#{node_id} GROUP BY time(1d) into temperature.max.1d.node#{node_id};")
end

puts "== all nodes"
series = influxdb.query("SELECT * FROM temperature.max.1d;")
puts series

NODE_IDS.each do |node_id|
  puts "== node#{node_id}"
  series = influxdb.query("SELECT * FROM temperature.max.1d.node#{node_id};")
  puts series
end


puts
puts "= Mean temperature for node 2 for the last 24 hours"

series = influxdb.query("SELECT MEAN(temperature) FROM sensors WHERE time > NOW() - 24h AND node_id=2")
puts series


puts
puts "= Mode temperature for node 2 for the last 24 hours"

series = influxdb.query("SELECT MODE(temperature) FROM sensors WHERE time > NOW() - 24h AND node_id=2")
puts series


puts
puts "= Median temperature for node 2 for the last 24 hours"

series = influxdb.query("SELECT MEDIAN(temperature) FROM sensors WHERE time > NOW() - 24h AND node_id=2")
puts series


puts
puts "= Histogram temperature for node 2 for the last 24 hours"

series = influxdb.query("SELECT HISTOGRAM(temperature) FROM sensors WHERE time > NOW() - 24h AND node_id=2")
puts series


puts
puts "= Derivative temperature for node 2 for the last 24 hours"

series = influxdb.query("SELECT DERIVATIVE(temperature) FROM sensors WHERE time > NOW() - 24h AND node_id=2")
puts series


puts
puts "= Standard deviation temperature for node 2 for the last 24 hours"

series = influxdb.query("SELECT STDDEV(temperature) FROM sensors WHERE time > NOW() - 24h AND node_id=2")
puts series


puts
puts "= Nodes that have a low battery during last 24hours"

series = influxdb.query("SELECT DISTINCT(node_id) FROM sensors WHERE time > NOW() - 24h AND lowbat = true;")
puts series


puts
puts "= Nodes that have a low vcc during last 24hours"

# cf. http://nathan.chantrell.net/tinytx-wireless-sensor/
# "The maximum voltage is 3.8v and minimum for the RFM12B to work is around 2.2v although the operational minimum for a complete sensor
#  will depend on the characteristics of the actual sensing device used, for example a DS18B20 worked down to around 2.3v
#  in my real word tests (data sheet value 3v) but the DHT22 only worked down to 2.96v (data sheet value 3v)."
series = influxdb.query("SELECT DISTINCT(node_id) FROM sensors WHERE (time > NOW() - 24h) AND (vcc < 2960);")
puts series
puts "ISSUE => Entries with 'null' values are catched by the < operator"
