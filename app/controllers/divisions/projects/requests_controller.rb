class Divisions::Projects::RequestsController < ApplicationController
  def index
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
end
