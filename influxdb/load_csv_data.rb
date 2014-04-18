#!/usr/bin/env ruby
require 'rubygems'
require 'influxdb'
require 'csv'
require 'time'

influxdb = InfluxDB::Client.new(:host => "127.0.0.1")

database = 'test'
username = 'root'
password = 'root'

influxdb = InfluxDB::Client.new(database, :username => username, :password => password)

influxdb.delete_database(database) rescue nil
influxdb.create_database(database)

nb = 0

CSV.foreach("./data.csv", :headers => true) do |row|
  point = { }

  # node_id,at,temperature,humidity,light,motion,lowbat,vcc
  row.each do |key, val|
    next if val.nil? || (val.strip == "")

    case key
    when 'node_id', 'humidity', 'light', 'vcc'
      point[key] = val.to_i
    when 'temperature'
      point[key] = val.to_f
    when 'motion', 'lowbat'
      point[key] = (val == '1') ? true : false
    when 'at'
      point['time'] = val.to_i
    end
  end

  influxdb.write_point('sensors', point)
  nb += 1
end

puts "Wrote #{nb} points in 'sensors' time series"
