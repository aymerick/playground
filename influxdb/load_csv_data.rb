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

puts "Deleting database: #{database}"
influxdb.delete_database(database) rescue nil

puts "Creating database: #{database}"
influxdb.create_database(database)

def load_csv!(influxdb, start_time)
  first_point_time = nil
  last_point       = nil
  nb               = 0
  finished         = false

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
        if first_point_time
          point['time'] = start_time + (val.to_i - first_point_time)
        else
          point['time'] = start_time

          first_point_time = val.to_i
        end
      end
    end

    finished = (point['time'] > Time.now.to_i)
    break if finished

    influxdb.write_point('sensors', point)

    nb += 1
    last_point = point
  end

  return [ nb, last_point['time'], finished ]
end

nb_total = 0

delta_time = 30 * 24 * 60 * 60 # (365 * 24 * 60 * 60)
start_time = first_start_time = (Time.now - delta_time).to_i
last_time  = nil
finished   = false

puts "Writing points starting from: #{Time.at(start_time)}"

while !finished do
  nb_inserted, last_time, finished = load_csv!(influxdb, start_time)

  nb_total += nb_inserted
  puts "[#{Time.at(last_time)}] Wrote #{nb_total} points"
  start_time = last_time + 5
end

puts "Wrote #{nb_total} points in 'sensors' time series from #{Time.at(first_start_time)} to #{Time.at(last_time)}"
