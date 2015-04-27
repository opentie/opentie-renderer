class DivisionsController < ApplicationController
  def show
    id = URI.encode params[:id]
    res = api.get("/divisions/#{id}")
    @json = res.body
    @members = @json['payload']['members'] || []
  end
end
