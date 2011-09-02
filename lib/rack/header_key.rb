module Rack
  class HeaderKey
    AUTH_HEADER = "X_AUTHORIZATION_KEY".freeze

    def initialize(app, options)
      @app = app
      @secret = options.fetch(:key)
      @path = options.fetch(:path, "/")

      unless @path =~ %r{^/}
        raise ArgumentError, "Please provide a path with a leading /"
      end
      @app
    end

    def call(env)
      self.dup._call(env)
    end

    def _call(env)
      @request = Rack::Request.new env
      if protected_path?
        if token_ok?
          @app.call(env)
        else
          [401, {'Content-Type' => 'text/plain; charset=utf-8'}, "Unauthorized"]
        end
      else
        @app.call(env)
      end
    end

    private

    def token_ok?
      @request.env[AUTH_HEADER] == @secret
    end

    def protected_path?
      @request.path =~ %r/^#{@path}/
    end
  end
end
