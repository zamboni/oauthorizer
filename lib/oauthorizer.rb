require "oauthorizer/version"
require 'capybara'
require 'capybara/dsl'

module Oauthorizer
  class Token
    include Capybara::DSL
    def get_google_code
      Capybara.default_driver = :selenium
      Capybara.server_port    = 3030
      self.visit "https://accounts.google.com/o/oauth2/auth?" +
        "scope=https://www.googleapis.com/auth/latitude.all.best+https://www.googleapis.com/auth/userinfo.profile+https://www.googleapis.com/auth/userinfo.email" + 
        "&redirect_uri=http://localhost:3030/callbacks/google.json" +
        "&response_type=code" + 
        "&client_id=26827780047.apps.googleusercontent.com" + 
        "&approval_prompt=force" + 
        "&access_type=offline"
      fill_in 'Email', with: 'test@rebelhold.com'
      fill_in 'Passwd', with: 'rht3sting'
      click_button 'signIn'
      click_button 'submit_approve_access'

      token = JSON.parse(page.text)
   end  
   def get_google_token_hash

    oautherizer_keys = YAML.load_file(File.join(Rails.root, 'config', 'oautherizer_config.yml'))['google']
    Capybara.default_driver = :selenium
    Capybara.server_port    = oautherizer_keys['server_port']
    self.visit "https://accounts.google.com/o/oauth2/auth?" +
      "scope=#{oautherizer_keys['scope']}" + 
      "&redirect_uri=#{oautherizer_keys['redirect_uri']}" +
      "&client_id=#{oautherizer_keys['client_id']}" + 
      "&response_type=code" + 
      "&approval_prompt=force" + 
      "&access_type=offline"
    fill_in 'Email', with: oautherizer_keys['user_email']
    fill_in 'Passwd', with: oautherizer_keys['user_password']
    click_button 'signIn'
    click_button 'submit_approve_access'
    debugger

    token = JSON.parse(page.text)
   end
   def self.update_from_token_hash provider_type, token_hash
    config_file = File.join(Rails.root, 'config', 'oautherizer_config.yml')
    credentials ||= YAML.load_file(config_file)

    credentials[provider_type].merge!(token_hash)

    new_file = File.open(config_file, 'w+')
    new_file.write(credentials.to_yaml.gsub("---\n", ''))
    new_file.close
   end 
 end
end
