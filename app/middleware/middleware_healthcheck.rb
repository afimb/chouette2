class MiddlewareHealthcheck  
  OK_RESPONSE = [ 200, { 'Content-Type' => 'text/plain' }, ["It's alive!".freeze] ]

  def initialize(app)
    @app = app
  end

  def call(env)
    if env['PATH_INFO'.freeze] == '/healthcheck'.freeze
      return OK_RESPONSE
    else
      @app.call(env)
    end
  end
end  