require 'oauthorizer/rack/oauthorizer'
require "oauthorizer/version"
require 'capybara'
require 'capybara/dsl'

module Oauthorizer
  class Token
    include Capybara::DSL
    def get_google_token_hash
      config_file             = File.join(Rails.root, 'config', 'oauthorizer_config.yml')
      oauthorizer_keys        = YAML.load_file(config_file)['google']
      if oauthorizer_keys['expires_at'].nil? || oauthorizer_keys['expires_at'] < Time.now
        Capybara.default_driver = :selenium
        Capybara.server_port    = oauthorizer_keys['server_port']
        self.visit "https://accounts.google.com/o/oauth2/auth?" +
          "scope=#{oauthorizer_keys['scope']}" + 
          "&redirect_uri=#{oauthorizer_keys['redirect_uri']}" +
          "&client_id=#{oauthorizer_keys['client_id']}" + 
          "&response_type=code" + 
          "&approval_prompt=force" + 
          "&access_type=offline"
        fill_in 'Email', with: oauthorizer_keys['user_email']
        fill_in 'Passwd', with: oauthorizer_keys['user_password']
        click_button 'signIn'
        click_button 'submit_approve_access'
   
        parsed_response = JSON.parse page.text 
        self.update_from_token_hash 'google', parsed_response, 'expires_in'
   
        parsed_response
      else
        oauthorizer_keys
      end
    end

    def get_facebook_token_hash
      config_file             = File.join(Rails.root, 'config', 'oauthorizer_config.yml')
      oauthorizer_keys        = YAML.load_file(config_file)['facebook']
      if oauthorizer_keys['expires_at'].nil? || oauthorizer_keys['expires_at'] < Time.now
        Capybara.default_driver = :selenium
        Capybara.server_port    = oauthorizer_keys['server_port']
        self.visit "https://www.facebook.com/dialog/oauth?" +
          "client_id=#{oauthorizer_keys['client_id']}" +
          "&redirect_uri=#{oauthorizer_keys['redirect_uri']}" +
          "&scope=#{oauthorizer_keys['scope']}" +
          "&state=#{oauthorizer_keys['state']}"
       fill_in 'email', with: oauthorizer_keys['user_email']
       fill_in 'pass', with: oauthorizer_keys['user_password']
       find('#loginbutton').click
       find('#grant_required_clicked').click  if page.has_css?('#grant_required_clicked')
       find('#grant_clicked').click           if page.has_css?('#grant_clicked')

       parsed_response = JSON.parse page.text
       self.update_from_token_hash 'facebook', parsed_response, 'expires'

       parsed_response
      else
       oauthorizer_keys
      end
    end

    def get_foursquare_token_hash
      config_file             = File.join(Rails.root, 'config', 'oauthorizer_config.yml')
      oauthorizer_keys        = YAML.load_file(config_file)['foursquare']
      if oauthorizer_keys['access_token'].nil? 
        Capybara.default_driver = :selenium
        Capybara.server_port    = oauthorizer_keys['server_port']
        self.visit "https://www.foursquare.com/oauth2/authenticate?" +
          "client_id=#{oauthorizer_keys['client_id']}" +
          "&redirect_uri=#{oauthorizer_keys['redirect_uri']}" +
          "&response_type=code" 
        find('.newGreenButton').click
        fill_in 'username', with: oauthorizer_keys['user_email']
        fill_in 'password', with: oauthorizer_keys['user_password']
        find('.greenButton').click
        # find('.newGreenButton').click

        parsed_response = JSON.parse page.text
        self.update_from_token_hash 'foursquare', parsed_response

        parsed_response
      else
        oauthorizer_keys
      end
    end

    def update_from_token_hash provider_type, token_hash, time_string=nil
      config_file = File.join(Rails.root, 'config', 'oauthorizer_config.yml')
      credentials ||= YAML.load_file(config_file)
      credentials[provider_type].merge!(token_hash)
      credentials[provider_type].merge!('expires_at' => (Time.now + token_hash[time_string].to_i.seconds)) unless time_string.nil?

      new_file = File.open(config_file, 'w+')
      new_file.write(credentials.to_yaml.gsub("---\n", ''))
      new_file.close
    end 

    def self.get_config_file
      YAML.load_file(File.expand_path('config/oauthorizer_config.yml'))
    end
  end
end
