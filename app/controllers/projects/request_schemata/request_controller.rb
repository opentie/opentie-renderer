class Projects::RequestSchemata::RequestController < ApplicationController
  def show
    api_call
  end

  def edit
    api_call
  end

  def update
    @api_body = { payload: {}, status: 1 }

    if params[:refuse].nil?
      @api_body = { payload: params[:formalizr], status: 0 }
    end

    api_call
    redirect_to request.path_info
  end
end
