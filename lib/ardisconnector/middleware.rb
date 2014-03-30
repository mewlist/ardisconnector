module Ardisconnector
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      res = @app.call env
      res[2] = Rack::BodyProxy.new(res[2]) do
        conn = ActiveRecord::Base.connection
        conn.disconnect!
        ActiveRecord::Base.connection_pool.remove conn
      end
      res
    end
  end
end
