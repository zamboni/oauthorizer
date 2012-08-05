require 'rails'
require 'action_controller/railtie'
 
module RailsApp
  class Application < Rails::Application
 
    routes.draw do
      resources :callbacks do
        collection do
          get 'google'
        end
      end

      get  '/' => 'rails/profiles#show'
    end
  end
 
  class ProfilesController < ActionController::Base
    def show
      render text: 'heyo!'
    end
  end
end