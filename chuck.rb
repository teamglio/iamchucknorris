require 'sinatra'
require 'rest_client'
require 'json'

get '/' do
	@joke = JSON.load(RestClient.get 'http://api.icndb.com/jokes/random?exclude=[explicit,nerdy]')["value"]["joke"]
	@mixup_ad = RestClient.get 'http://serve.mixup.hapnic.com/8215822'
	erb :joke
end