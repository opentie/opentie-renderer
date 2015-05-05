class AccountsController < ApplicationController
  def new
    api_call
  end

  def create
    @api_body = params.slice(
      :payload, :name, :email,
      :password, :password_confirmation
    )
    api_call
  end
end
