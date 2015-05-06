class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ApiClient::Unauthorized do
    redirect_to controller: '/sessions', action: :new, redirect_to: request.url
  end

  rescue_from ApiClient::NotFound do
    @does_not_have_sidebar = true
    @is_login_page = true
    render 'errors/404'
  end
  
  before_action :set_default_request

  def api_client
    ApiClient.new(request, response)
  end

  def set_default_request
    @api_body = nil
    @api_method = params[:_method].try(:downcase).try(:to_sym) || request.method_symbol
    @api_path = request.path_info
    @api_query = URI.parse(request.url).query
  end

  def api_call
    path = @api_path
    path += "?#{@api_query}" unless @api_query.nil?
    response = api_client.run(@api_method, path, @api_body)
    case response.status
    when 200...300, 400
      @response_json = response.body
    when 301..303
      redirect_to response.headers['x-location']
    end
  end
end
