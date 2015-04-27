class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter do
    @request_schemata =
      [{
         _type: 'request_schemata',
         id: 'hogehoge',
         name: 'ほげほげ'
       },
       {
         _type: 'request_schemata',
         id: 'fugapiyo',
         name: 'ふがぴよ'
       }]
  end

  rescue_from ApiClient::NotAuthorized do
    redirect_to '/login'
  end

  def api
    ApiClient.new(request, response)
  end
end
