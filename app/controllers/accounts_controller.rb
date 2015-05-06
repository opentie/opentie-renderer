class AccountsController < ApplicationController
  def new
    @does_not_have_sidebar = true
    @is_login_page = true

    api_call
  end

  def create
    @does_not_have_sidebar = true
        
    @api_body = params.slice(
      :payload, :name, :email,
      :password, :password_confirmation
    )
    api_call
  end

  def confirm
    @does_not_have_sidebar = true

    api_call
  end
end
