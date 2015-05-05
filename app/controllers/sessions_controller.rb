class SessionsController < ApplicationController
  def new
    @does_not_have_sidebar = true
    @is_login_page = true
  end

  def create
    @api_body = { email: params[:email], password: params[:password] }
    api_call
    redirect_to URI.parse(params[:redirect_to] || '/').path
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
