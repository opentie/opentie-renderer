class ApiClient
  COOKIE_KEY = '_application_session'
  def initialize(request, response)
    @request = request
    @response = response
    @conn = Faraday::Connection.new(url: 'http://127.0.0.1:4000') do |faraday|
      faraday.request  :url_encoded
      faraday.request  :json
      faraday.response :raise_error
      faraday.response :json
      faraday.adapter  Faraday.default_adapter
    end
  end

  def run(method, path, body)
    headers = { 'Cookie': @request.headers['Cookie'] }.compact
    begin
      response = @conn.run_request(method, "/api/v1#{path}", body, headers)
    rescue Faraday::ClientError => err
      raise NotAuthorized if err.response[:status] == 401
      raise err
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

  class NotAuthorized < StandardError ; end
end
