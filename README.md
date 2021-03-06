# Capistrano::nodebrew

[![Gem Version](https://badge.fury.io/rb/capistrano-nodebrew.svg)](http://badge.fury.io/rb/capistrano-nodebrew)

[nodebrew](https://github.com/hokaccha/nodebrew) support for Capistrano 3.x

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano', '~> 3.1'
    gem 'capistrano-nodebrew'

And then execute:

    $ bundle install

## Usage

    # Capfile
    require 'capistrano/nodebrew'

    # config/deploy.rb
    set :nodebrew_type, :user # or :system, depends on your nodebrew setup
    set :nodebrew_node, 'io@v2.5.0'

    set :nodebrew_map_bins, %w{npm node iojs} # default values
    set :nodebrew_roles, :all # default value

If your nodebrew is located in some custom path, you can use `nodebrew_custom_path` to set it.

## Acknowledgment

Thanks a lot to [Capistrano::rbenv](https://github.com/capistrano/rbenv).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
