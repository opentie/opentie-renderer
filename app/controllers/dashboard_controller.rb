class DashboardController < ApplicationController
  def index
    @does_not_have_sidebar = true

    res = api.get('/dashboard')
    @json = res.body
    @projects = @json["projects"] || []
    @divisions = @json["divisions"] || []
  end
end
