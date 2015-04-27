class SessionsController < ApplicationController
  def new
    render :new, layout: nil
  end

  def create
    api.post('/login', email: params[:email], password: params[:password])
    redirect_to '/'
  end
end
