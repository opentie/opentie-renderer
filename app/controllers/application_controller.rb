class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ApiClient::Unauthorized do
    redirect_to controller: '/sessions', action: :new, redirect_to: request.path_info
  end

  before_action :set_default_request

  def api_client
    ApiClient.new(request, response)    
  end

  def set_default_request
    @api_body = nil
    @api_method = params[:_method].try(:downcase).try(:to_sym) || request.method_symbol
    @api_path = request.path_info
  end
  
  def api_call
    @response_json = api_client.run(@api_method, @api_path, @api_body).body
  end
end
