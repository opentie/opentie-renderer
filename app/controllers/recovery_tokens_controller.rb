class RecoveryTokensController < ApplicationController
  # /recovery_tokens
  def new
    @is_login_page = true
    @does_not_have_sidebar = true
  end

  def create
    @is_login_page = true
    @does_not_have_sidebar = true
    @api_body = { email: params[:email] }
    @api_path = '/recovery_tokens'
    api_call
  rescue => e
    @is_login_page = true
    @does_not_have_sidebar = true
    @invalid_email = true
    render :new
  end

  # /reset_password
  def edit
    redirect_to :dashboard if params[:token].nil?
    @is_login_page = true
    @does_not_have_sidebar = true
  end

  def reset
    @is_login_page = true
    @does_not_have_sidebar = true
    @api_body = {
      password: params[:password],
      password_confirmation: params[:password_confirmation],
      token: params[:token]
    }
    @api_path = "/recovery_tokens/#{params[:token]}"
    api_call
  rescue ApiClient::Unauthorized
    @is_login_page = true
    @does_not_have_sidebar = true
    @invalid_password = true
    render :edit
  rescue # ApiClient::NotFound
    @is_login_page = true
    @does_not_have_sidebar = true
    @invalid_token = true
    render :edit
  end
end
