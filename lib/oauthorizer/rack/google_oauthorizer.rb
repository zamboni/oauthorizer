module Rack
  class GoogleOauthorizer
    def initialize(app, options={})
      @app = app
      @options = options
    end

    def call(env)
      debugger
      # @request = Rack::Request.new(env)
      # if @request.path == '/callbacks/google.json'
      #   oautherizer_keys = YAML.load_file(File.join(Rails.root, 'config', 'oautherizer_config.yml'))['google']

      #   post_hash = {
      #     code:           @request.params['code'], 
      #     grant_type:     'authorization_code', 
      #     redirect_uri:   'http://localhost:3030/callbacks/google.json',
      #     client_id:      @options['google']['key'], 
      #     client_secret:  @options['google']['secret']
      #   }
      #   token_response = HTTParty.post('https://accounts.google.com/o/oauth2/token', body: post_hash)
      #   [200, {"Content-Type"=> 'application/json'}, token_response.to_json]
      #   # [200, {"Location" => @request.env['HTTP_HOST'] + '/users/providers/google/authorize?' + @request.url.split('?').last}, self]
      # end
    end
  end
end
