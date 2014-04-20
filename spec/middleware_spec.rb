require 'spec_helper'

class ExampleApplication
  def call(env)
    [
      200,
      { 'Content-Type' => 'text/html' },
      ['example response']
    ]
  end
end

describe Ardisconnector::Middleware do
  let(:env)        { {} }
  let(:app)        { ExampleApplication.new }
  let(:middleware) { Ardisconnector::Middleware.new app }

  it 'returns response with BodyProxy' do
    middleware.call( env )[2].class.should == Rack::BodyProxy
  end

  describe Rack::BodyProxy do
    let(:connection)      { double("connection") }
    let(:connection_pool) { double("conection_pool") }
    let(:model)           { double("Model", connection: connection, connection_pool: connection_pool) }
    before do
      ActiveRecord::Base.stub( :connection ) { connection }
      ActiveRecord::Base.stub( :connection_pool ) { connection_pool }
      Ardisconnector::Middleware.models << model
    end

    it 'should disconnect connection when close' do
      connection.should_receive( :disconnect! ).twice
      connection_pool.should_receive( :remove ).twice.with( connection )
      middleware.call( env )[2].close
    end
  end
end

