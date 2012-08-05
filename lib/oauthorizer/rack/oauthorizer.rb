module Rack
  class Oauthorizer
    require 'httparty'
    require 'oauthorizer'
    def initialize(app, options={})
      @app = app
      @options = options
    end

    def call(env)
      @request = Rack::Request.new(env)
      if @request.path == '/callbacks/google.json'
        # oauthorizer_keys = Oauthorizer::Token.get_config_file['google'] 
        post_hash = {
          code:           @request.params['code'], 
          grant_type:     'authorization_code', 
          redirect_uri:   'http://localhost:3030/callbacks/google.json',
          client_id:      @options['google']['client_id'], 
          client_secret:  @options['google']['client_secret']
        }
        token_response = HTTParty.post('https://accounts.google.com/o/oauth2/token', body: post_hash).parsed_response
        [200, {"Content-Type"=> 'application/json'}, [token_response.to_json]]
      elsif @request.path == '/callbacks/facebook.json'
        # oauthorizer_keys = Oauthorizer::Token.get_config_file['google'] 
        post_hash = {
          code:           @request.params['code'], 
          redirect_uri:   'http://localhost:3030/callbacks/facebook.json',
          client_id:      @options['facebook']['client_id'], 
          client_secret:  @options['facebook']['client_secret']
        }

        token_response = HTTParty.post('https://graph.facebook.com/oauth/access_token', body: post_hash).parsed_response

        parsed_response = Rack::Utils.parse_query token_response
        [200, {"Content-Type"=> 'application/json'}, [parsed_response.to_json]]
      elsif @request.path == '/callbacks/foursquare.json'
        # oauthorizer_keys = Oauthorizer::Token.get_config_file['google'] 
        post_hash = {
          code:           @request.params['code'], 
          grant_type:     'authorization_code', 
          redirect_uri:   'http://localhost:3030/callbacks/foursquare.json',
          client_id:      @options['foursquare']['client_id'], 
          client_secret:  @options['foursquare']['client_secret']
        }

        token_response = HTTParty.post('https://foursquare.com/oauth2/access_token', body: post_hash).parsed_response
        [200, {"Content-Type"=> 'application/json'}, [token_response.to_json]]
      end
    end
  end
end
