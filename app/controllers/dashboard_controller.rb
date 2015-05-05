class DashboardController < ApplicationController
  def index
    @api_path = '/dashboard'
    @does_not_have_sidebar = true
    api_call
  end
end
