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
    let(:connection)      { Object.new }
    let(:connection_pool) { Object.new }
    before do
      ActiveRecord::Base.stub( :connection ) { connection }
      ActiveRecord::Base.stub( :connection_pool ) { connection_pool }
    end

    it 'should disconnect connection when close' do
      connection.should_receive( :disconnect! )
      connection_pool.should_receive( :remove ).with( connection )
      middleware.call( env )[2].close
    end
  end
end

