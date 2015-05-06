class ProjectsController < ApplicationController
  def new
    @does_not_have_sidebar = true
    api_call
  end

  def show
    api_call
  end

  def create
    @does_not_have_sidebar = true
    @api_body = params.slice('payload')
    api_call
    validities = @response_json['validities']
    render :new unless validities.nil?
  end
end
