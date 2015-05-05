class SessionsController < ApplicationController
  def new
    @does_not_have_sidebar = true
    @is_login_page = true
  end

  def create
    @api_body = { email: params[:email], password: params[:password] }
    api_call
    url = URI.parse(params[:redirect_to] || '/')
    url.userinfo = nil
    url.scheme = nil
    url.host = nil
    url.port = nil
    redirect_to url.normalize.to_s
  rescue ApiClient::Unauthorized
    @does_not_have_sidebar = true
    @is_login_page = true
    @invalid_email_or_password = true
    render :new
  end

  def edit
    @does_not_have_sidebar = true
    @is_login_page = true
  end

  def destroy
    api_call
    redirect_to '/'
  end
end
