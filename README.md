# RedisField [![Build Status](https://travis-ci.org/konukhov/redis_field.svg?branch=master)](https://travis-ci.org/konukhov/redis_field) [![Code Climate](https://codeclimate.com/github/konukhov/redis_field.png)](https://codeclimate.com/github/konukhov/redis_field)

RedisField is a simple Ruby gem that stores model-specific data to Redis just like normal ActiveRecord attributes.

Great for caches, API responses etc.

## Installation

You will need ActiveRecord 3.2+ (oops, gotta test it).

Add this line to your application's Gemfile:

```ruby
  gem 'redis_field'
```

And then execute:

    $ bundle


## Usage

### 1. Specify field names in your model

```ruby
  class User < ActiveRecord::Base
    redis_field :some_data

    # redis_fields is just an alias to redis_field
    redis_fields :facebook_friend_ids, :last_logged_in
  end
```

### 2. Use these fields just like normal AR attributes

```ruby
  user = User.last
```

```ruby
  user.some_data = "Testing redis_field"
  user.save
  user.reload.some_data # -> "Testing redis_field"
```

```ruby
  user.update_attributes(last_logged_in: Time.now)
  user.reload.last_logged_in # -> 2014-04-05 01:00:00 +0000
```



**NB** This library is not an ORM for Redis, so it simply marshalls data before storing to Redis. There's no types coercion or anything like that.

More docs and features soon. :heart:

## Testing

Just run

```
$ rake spec
```

See [Appraisal](https://github.com/thoughtbot/appraisal) for testing against different ActiveRecord versions.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
