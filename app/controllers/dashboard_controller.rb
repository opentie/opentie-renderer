class DashboardController < ApplicationController
  def index
    @projects = [{
                   _type: "project",
                   id: "",
                   name: "tkbctf6"
                 }]
  end
end
