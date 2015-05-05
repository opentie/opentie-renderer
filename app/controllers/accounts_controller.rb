class AccountsController < ApplicationController
  def new
    @does_not_have_sidebar = true

    api_call
  end

  def create
    @api_body = params.slice(
      :payload, :name, :email,
      :password, :password_confirmation
    )
    api_call
  end

  def confirm
    api_call
  end
end
