# Bernard

Sends event data to visualisation services.

Currently supporting:
- Keen.io

![bernard](http://dogkeg.com/wp-content/uploads/2015/10/saint_bernard__dog_keg_barrel-30-640x427-e1446127647535.jpg)


## Install

Add this line to your application's Gemfile:
```ruby
gem 'bernard', '~> 2.0.0'
```

And then execute:
```sh
$ bundle
```

## Basic setup

Create a new client on the fly:
```ruby
client = Bernard::Keen::Client.new(
  application_name: '<YOUR APPLICATION NAME>'
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

Increment an event that has occurred by 5.
```ruby
client.count('visitors', '5')
```

### Gauge

Update an event to a new value.
```ruby
client.gauge('office_noise_level', '43')
```

### Splat

Update multiple events at once
```
events = [
  { value: { name: 'ruby', count: 1 }, application_name: 'demo', type: 'github_language'} },
  { value: { name: 'go', count: 2 }, application_name: 'demo', type: 'github_language'} },
]
client.splat(events)
```

---

## Advanced configuration

### Initializer
Create a new initializer `config/bernard.rb` in your application
```ruby
Bernard::Keen::Client.configure do |client|
  client.config = {
    application_name: '<YOUR APPLICATION NAME>',
    project_id: '<YOUR PROJECT ID>',
    write_key: '<YOUR WRITE KEY>',
    read_key: '<YOUR READ KEY>'
  }
end
```

### Run asynchronously

Given that this Gem is making HTTP requests which can be slow, we'd advise using
a worker like [Sidekiq](https://github.com/mperham/sidekiq).

For example adding this to your applications's `workers/bernard_worker.rb` file:
```ruby
require 'bernard'

class BernardWorker
  include Sidekiq::Worker

  def perform(event_type, event_name, value = 0)
    case event_type.to_sym
    when :tick then Bernard::Keen::Client.new.tick(event_name)
    when :count then Bernard::Keen::Client.new.count(event_name, value)
    when :gauge then Bernard::Keen::Client.new.gauge(event_name, value)
    else
    end
  end
end
```

and invoke using this worker instead to ensure it doesn't interrupt your application's processes:

```ruby
BernardWorker.perform_async(:tick, :vote)
BernardWorker.perform_async(:count, :visitors, 3)
BernardWorker.perform_async(:gauge, :temperature, 32.5)
```

## License

(c) 2016 The Dextrous Web Ltd. Released under the MIT license.
