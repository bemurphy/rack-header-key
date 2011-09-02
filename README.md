# Rack::HeaderKey #

Rack::HeaderKey is Rack Middleware for providing authorization for requests via
an HTTP header.  This is useful in instances where you want to authenticate some
client of yours to an API where it's easier or preferrable over HTTP basic
authentication.

## Installation ##

install it via rubygems:

```
gem install rack-header-key
```

or put it in your Gemfile:

```ruby
# Gemfile

gem 'rack-header-key', :require => 'rack/header_key'
```


## Usage ##

In a Rack application:

```ruby
# app.rb

use Rack::HeaderKey, :path => "/api", :key => "shared_key"
```

The optional `:path` value determines a specific path you choose to protect.
Leaving it off will call the root path to be protected entirely.

## Copyright

Copyright © 2011 Brendon Murphy. See [MIT-LICENSE](https://github.com/bemurphy/rack-header-key/blob/master/MIT-LICENSE) for details.
