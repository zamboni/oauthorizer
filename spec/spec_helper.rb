# load test applications
Dir[File.expand_path('../../apps/*.rb', __FILE__)].each do |f| 
  require f
end
require 'capybara/rspec'
require 'oauthorizer/rack/oauthorizer.rb'
require 'oauthorizer'
require 'rspec/rails'

require 'YAML'
oauthorizer_keys = YAML.load_file(File.expand_path('config/oauthorizer_config.yml'))


 

# configure rails application to use MyRackMiddleware
RailsApp::Application.configure do |app|

  app.middleware.insert_before ActionDispatch::Static, Rack::Oauthorizer, oauthorizer_keys

end