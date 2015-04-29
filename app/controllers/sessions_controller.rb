class SessionsController < ApplicationController
  def new
    @does_not_have_sidebar = true
    @is_login_page = true
  end

  def create
    api.post('/login', email: params[:email], password: params[:password])
    redirect_to '/'
  end

  def edit
    @does_not_have_sidebar = true
    @is_login_page = true
  end

  def destroy
    api.post('/logout')
    redirect_to '/'
  end
end
