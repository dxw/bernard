# Bernard

Sends event data to visualisation services.

![bernard](http://dogkeg.com/wp-content/uploads/2015/10/saint_bernard__dog_keg_barrel-30-640x427-e1446127647535.jpg)


## Install

Add this line to your application's Gemfile:
```ruby
gem 'bernard', '~> 0.3.0'
```

And then execute:
```sh
$ bundle
```

## Setup
To use Bernard you can either create an initializer or construct it as you need it.

Create a new initializer `config/bernard.rb` in your application
```ruby
Bernard::Keen::Client.configure do |client|
  client.config = {
    uri: URI('https://api.keen.io'),
    project_id: '<YOUR PROJECT ID>',
    write_key: '<YOUR WRITE KEY>',
    read_key: '<YOUR READ KEY>'
  }
end
```

OR

Create a new client on the fly:
```ruby
client = Bernard::Keen::Client.new(
  uri: URI('https://api.keen.io')
  project_id: '<YOUR PROJECT ID>'
  write_key: '<YOUR WRITE KEY>'
  ready_key: '<YOUR READ KEY>'
)
```

## Usage

### Tick

Increment an event that has occurred by 1.
```ruby
client.tick('foo')
```

### Count

Increment an event that has occurred by 1.
```ruby
client.count('visitors', '10')
```

### Gauge

Update an event to a new value.
```ruby
client.gauge('office_noise_level', '43')
```

## License

(c) 2016 The Dextrous Web Ltd. Released under the MIT license.
