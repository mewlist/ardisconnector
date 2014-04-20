module Ardisconnector
  class Middleware
    class << self
      def models
        @models ||= [ActiveRecord::Base]
        @models
      end
    end

    def initialize(app)
      @app = app
    end

    def call(env)
      res = @app.call env
      res[2] = Rack::BodyProxy.new(res[2]) do
        self.class.models.each do |klass|
          conn = klass.connection
          conn.disconnect!
          klass.connection_pool.remove conn
        end
      end
      res
    end
  end
end
