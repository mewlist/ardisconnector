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
    expect(middleware.call( env )[2].class).to eq Rack::BodyProxy
  end

  describe Rack::BodyProxy do
    let(:connection)      { double("connection") }
    let(:connection_pool) { double("conection_pool") }
    let(:model)           { double("Model", connection: connection, connection_pool: connection_pool) }
    before do
      allow(ActiveRecord::Base).to receive( :connection ) { connection }
      allow(ActiveRecord::Base).to receive( :connection_pool ) { connection_pool }
      Ardisconnector::Middleware.models << model
    end

    it 'should disconnect connection when close' do
      expect(connection).to receive( :disconnect! ).twice
      expect(connection_pool).to receive( :remove ).twice.with( connection )
      middleware.call( env )[2].close
    end
  end
end
