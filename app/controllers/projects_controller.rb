class ProjectsController < ApplicationController
  def new
    @does_not_have_sidebar = true
    api_call
  end

  def show
    api_call
  end

  def create
    @api_body = {
      payload: params['payload'],
      name: params['payload']['project_name'],
    }
    api_call
    @does_not_have_sidebar = true
  end
end
