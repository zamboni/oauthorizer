require 'capybara/rspec'
require 'oauthorizer/rack/google_oauthorizer.rb'
require 'oauthorizer'

require 'YAML'
oautherizer_keys = YAML.load_file(File.expand_path('config/oautherizer_config.yml'))['google']

# load test applications
Dir[File.expand_path('../../apps/*.rb', __FILE__)].each do |f| 
  require f
end
 

# configure rails application to use MyRackMiddleware
RailsApp::Application.configure do |app|

  app.middleware.insert_before ActionDispatch::Static, Rack::GoogleOauthorizer, oautherizer_keys

end