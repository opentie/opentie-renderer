class DashboardController < ApplicationController
  def index
    @does_not_have_sidebar = true
    @projects = [{
                   _type: "project",
                   id: "",
                   name: "tkbctf6"
                 }]
  end
end
