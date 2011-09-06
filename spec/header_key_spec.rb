require 'spec_helper'

RSpec::Matchers.define :be_allowed do
  match do |response|
    response.status.should == 200
    response.body.should == "success"
  end
end

RSpec::Matchers.define :be_unauthorized do
  match do |response|
    response.status.should == 401
  end
end

describe "Requests using Rack::HeaderKey" do
  let(:key) { "sekret" }
  let(:app) {
    Rack::Builder.new do
      use Rack::HeaderKey, :key => "sekret", :path => "/api"
      run lambda { |env| [200, {'Content-Type' => "text/plain"}, ["success"]]}
    end
  }

  it "raise an argument error if the initialization path option doesn't start with /" do
    app = Rack::Builder.new do
      use Rack::HeaderKey, :key => "sekret", :path => "bad_path"
      run lambda { |env| [200, {'Content-Type' => "text/plain"}, ["success"]]}
    end

    lambda {
      Rack::MockRequest.new(app).get('/test')
    }.should raise_error(ArgumentError)
  end

  context "for the protected path" do
    it "are allowed if the proper key is present in X_AUTHORIZATION_KEY" do
      response = Rack::MockRequest.new(app).get('/api/test', "X_AUTHORIZATION_KEY" => key)
      response.should be_allowed
    end

    it "are allowed if the proper key is present in HTTP_X_AUTHORIZATION_KEY" do
      response = Rack::MockRequest.new(app).get('/api/test', "HTTP_X_AUTHORIZATION_KEY" => key)
      response.should be_allowed
    end

    it "are unauthorized if the proper key is not in X_AUTHORIZATION_KEY" do
      response = Rack::MockRequest.new(app).get('/api/test', "X_AUTHORIZATION_KEY" => "bogus_key")
      response.should be_unauthorized
    end
  end

  context "for an unprotected path" do
    it "are allowed when no key is given" do
      response = Rack::MockRequest.new(app).get('/test')
      response.should be_allowed
    end

    it "are allowed even if an improper key is given" do
      response = Rack::MockRequest.new(app).get('/test', "X_AUTHORIZATION_KEY" => "bogus_key")
      response.should be_allowed
    end
  end

  context "when no path is given" do
    it "the root path is protected" do
      app = Rack::Builder.new do
        use Rack::HeaderKey, :key => "sekret"
        run lambda { |env| [200, {'Content-Type' => "text/plain"}, ["success"]]}
      end
      response = Rack::MockRequest.new(app).get('/test', "X_AUTHORIZATION_KEY" => "bogus_key")
      response.should be_unauthorized
    end
  end
end

