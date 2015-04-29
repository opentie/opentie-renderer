class DashboardController < ApplicationController
  def index
    @does_not_have_sidebar = true

    res = api.get('/dashboard')
    @json = res.body
  end
end
