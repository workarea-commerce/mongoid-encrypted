# Mongoid::Encrypted

`mongoid-encrypted` provides simple encryption for mongoid fields utilizing the message encryption provided by Rails.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mongoid-encrypted'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mongoid-encrypted

## Usage

```ruby
class SuperSecret
  include Mongoid::Document
  include Mongoid::Encrypted

  field :access_code, type: String, encrypted: true
end
```

### Configuration

### Encryption Key

To match Rails conventions, `mongoid-encrypted` is configured to look for the encryption key in either an environment variable, or a key file. Either of these can be configured as desired if you are not using Rails, or wish to have a separate key for encrypted Mongoid fields.

```ruby
# Default
Mongoid::Encrypted.configuration.env_key #=> RAILS_MASTER_KEY
Mongoid::Encrypted.configuration.key_path #=> config/master.key
```

The environment variable will take precedence over the key file. If you want to change either of these values, you can do so during initialization of the application.

```ruby
Mongoid::Encrypted.configure do |config|
  config.env_key = 'MONGOID_ENCRYPTED_KEY'
  config.key_path = 'config/db.key'
end
```

### Rotations

`Mongoid::Encrypted.configuration.rotations`

`mongoid-encrypted` provides a mechanism to change keys or encryption while not losing data added with old values. Use this to add fallbacks to Workarea::Encryptor. See [the Rails guides on `ActiveSupport::MessageEncryptor`](https://edgeapi.rubyonrails.org/classes/ActiveSupport/MessageEncryptor.html) for info on options that can be passed to `#rotate`.

```ruby
Mongoid::Encrypted.configure do |config|
  config.rotations << ['PREVIOUS_KEY'].pack("H*")
  config.rotations << { cipher: 'aes-128-gcm' }
end  
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/mongoid-encrypted. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Mongoid::Encrypted project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/mongoid-encrypted/blob/master/CODE_OF_CONDUCT.md).
