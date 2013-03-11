class FisController < ApplicationController
require 'net/http'
require 'open-uri'
  def test
    method = '/dictionary'
    uri = URI.parse('http://priem.edu.ru:8000/import/importservice.svc')
    http = Net::HTTP.new(uri.host, uri.port)
    data = '<Root><AuthData><Login>it@isma.ivanovo.ru</Login><Pass>FdW5jz7e</Pass></AuthData></Root>'
    headers = {'Content-Type' => 'text/xml'}
    response = http.post(uri.path + method, data, headers)
    @response = response.body
  end
end
