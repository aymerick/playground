influxdb
========

## Install InfluxDB

Download instructions are [here](http://influxdb.org/download/).

On Mac, install [brew](http://brew.sh) first then:

```
$ brew update
$ brew install influxdb
```

Manually run InfluxDB with:

```
$ influxdb -config=/usr/local/etc/influxdb.conf
```

Then open [the admin page](http://127.0.0.1:8083), login with `root/root` and create a `test` database.


## Init database

Install ruby gem:

```
$ gem install influxdb
```

Load data:

```
$ ./run_sine_data.rb
```

Go to [the admin page](http://127.0.0.1:8083), select "Explore Data" on the "test database" then execute the query:

```
SELECT value FROM sine;
```

Kill the `run_sine_data.rb` script when you are done.


## Init database with sensors data

Load data:

```
$ ./load_csv_data.rb
```

Go to [the admin page](http://127.0.0.1:8083), select "Explore Data" on the "test database" then execute the query:

```
SELECT temperature FROM sensors WHERE node_id = '3'
```

```
SELECT * FROM sensors WHERE node_id='2';
```


## Query database

Query data:

```
$ ./query_data.rb
```


## Setup tasseo

Let's test the [tasseo](https://github.com/obfuscurity/tasseo) dashboard:

```
$ git clone git@github.com:obfuscurity/tasseo.git
$ cd tasseo
```

Edit file `dashboards/test.js`:

```
var period = 5;
var refresh = 5000;

var nodes = [ 2, 3, 4, 27, 28, 29 ];

var metrics = [
  {
    target: "value",
    series: "sine"
  }
];

_.each(nodes, function(node_id) {
  metrics.push({
    target: "temperature",
    series: "sensors",
    where: "node_id = " + node_id,
    warning: 21,
    critical: 25,
    alias: "Node " + node_id,
    unit: "C"
  });
}, this);
```

Launch tasseo:

```
$ bundle install
$ export INFLUXDB_URL=http://127.0.0.1:8086/db/test
$ export INFLUXDB_AUTH=root:root
$ foreman start
$ open http://127.0.0.1:5000
```

Launch live data:

```
$ ./run_csv_data.rb
$ ./run_sine_data.rb
```
