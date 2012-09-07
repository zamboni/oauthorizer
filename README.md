# Oauthorizer

A gem to automatically go out and grab new access tokens when making oauth calls. Then storing them in a yml file for later use and reference.

## Installation

Add this line to your application's Gemfile:

    gem 'oauthorizer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install oauthorizer

## Setup

Create a file in config/initializers/oauthorizer.rb

oauthorizer_keys = YAML.load_file(File.join(Rails.root, 'config', 'oauthorizer_config.yml'))

Rails.application.config.middleware.insert_before ActionDispatch::Static, Rack::Oauthorizer, oauthorizer_keys

Create a config file in your config directory.

google:
  client_id: 
  client_secret: 
  scope: https://www.googleapis.com/auth/latitude.all.best+https://www.googleapis.com/auth/userinfo.profile+https://www.googleapis.com/auth/userinfo.email
  redirect_uri: http://localhost:3030/callbacks/google.json
  server_port: 3030
  user_email: 
  user_password: 
facebook:
  client_id: 
  client_secret: 
  scope: publish_checkins
  redirect_uri: http://localhost:3030/callbacks/facebook.json
  server_port: 3030
  state: stuff
  user_email: 
  user_password: 
foursquare:
  client_id: 
  client_secret: 
  redirect_uri: http://localhost:3030/callbacks/foursquare.json
  server_port: 3030
  user_email: 
  user_password: 

Make sure that the port in your redirect_uri matches your server_port.

You must fill in information for the client_id, client_secret, user_email and password. The user email and password should be for a test account that you have setup.

## Usage

In your spec simply initialize Oauthorizer then set a variable for the token.

oauther = Oauthorizer::Token.new
token = oauther.get_google_token_hash
token = oauther.get_facebook_token_hash
token = oauther.get_foursquare_token_hash
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
