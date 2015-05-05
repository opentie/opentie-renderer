class ApiClient
  COOKIE_KEY = '_application_session'
  def initialize(request, response)
    @request = request
    @response = response
    @conn = Faraday::Connection.new(url: 'http://127.0.0.1:4000') do |faraday|
      faraday.request  :json
      #faraday.response :raise_error
      faraday.response :json
      faraday.adapter  Faraday.default_adapter
    end
  end

  def run(method, path, body = nil)
    headers = { Cookie: @request.headers['Cookie'] }.compact
    begin
      response = @conn.run_request(method, "/api/v1#{path}", body, headers)
      case response.status
      when 200, 201, 301..303
        response
      when 401
        raise Unauthorized
      when 404
        raise NotFound
      else
        binding.pry
        raise "unexpected response"
      end
    end
    @response.headers['Set-Cookie'] = response.headers['Set-Cookie']
    response
  end

  def get(path, body = nil)
    run(:get, path, body)
  end

  def put(path, body = nil)
    run(:put, path, body)
  end

  def post(path, body = nil)
    run(:post, path, body)
  end

  def delete(path, body = nil)
    run(:delete, path, body)
  end

  class Unauthorized < StandardError ; end
  class Forbidden < StandardError ; end
  class NotFound < StandardError ; end
end
