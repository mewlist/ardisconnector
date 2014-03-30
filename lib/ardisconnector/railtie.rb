module Ardisconnector
  class Railtie < Rails::Railtie
    initializer "ardisconnector.insert_middleware" do |app|
      app.config.middleware.insert_before 0, "Ardisconnector::Middleware"
    end
  end
end
