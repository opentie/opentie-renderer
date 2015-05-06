class Projects::InvitationsController < ApplicationController
  def index
    api_call
  end

  def new
    api_call
  end

  def create
    @api_body = params.slice(:email)
    api_call
  end
end
