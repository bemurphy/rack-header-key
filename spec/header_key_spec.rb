require 'spec_helper'

describe Rack::HeaderKey do
  let(:key) { "sekret" }
  let(:app) {
    Rack::Builder.new do
      use Rack::HeaderKey, :key => "sekret", :path => "/api"
      run lambda { |env| [200, {'Content-Type' => "text/plain"}, ["success"]]}
    end
  }

  it "raises an argument error if given a path option that doesn't start with /" do
    app = Rack::Builder.new do
      use Rack::HeaderKey, :key => "sekret", :path => "bad_path"
      run lambda { |env| [200, {'Content-Type' => "text/plain"}, ["success"]]}
    end

    lambda {
      Rack::MockRequest.new(app).get('/test')
    }.should raise_error(ArgumentError)
  end

  context "for the protected path" do
    it "returns 200 if the proper key is present in X_AUTHORIZATION_KEY" do
      response = Rack::MockRequest.new(app).get('/api/test', "X_AUTHORIZATION_KEY" => key)
      response.status.should == 200
      response.body.should == "success"
    end

    it "returns 401 if the the proper key is not in X_AUTHORIZATION_KEY" do
      response = Rack::MockRequest.new(app).get('/api/test', "X_AUTHORIZATION_KEY" => "bogus_key")
      response.status.should == 401
    end
  end

  context "for an unprotected path" do
    it "returns 200 when no key is given" do
      response = Rack::MockRequest.new(app).get('/test')
      response.status.should == 200
      response.body.should == "success"
    end

    it "returns 200 even if an improper key is given" do
      response = Rack::MockRequest.new(app).get('/test', "X_AUTHORIZATION_KEY" => "bogus_key")
      response.status.should == 200
      response.body.should == "success"
    end
  end

  context "when no path is given" do
    it "protects the root path" do
      app = Rack::Builder.new do
        use Rack::HeaderKey, :key => "sekret"
        run lambda { |env| [200, {'Content-Type' => "text/plain"}, ["success"]]}
      end
      response = Rack::MockRequest.new(app).get('/test', "X_AUTHORIZATION_KEY" => "bogus_key")
      response.status.should == 401
    end
  end
end

