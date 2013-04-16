require 'sinatra'
require 'rest-client'
require 'json'

enable :sessions

get '/' do
	@joke = JSON.load(RestClient.get 'http://api.icndb.com/jokes/random?exclude=[explicit,nerdy]')["value"]["joke"]
	@mixup_ad = RestClient.get 'http://serve.mixup.hapnic.com/9392697'
	session[:joke] = @joke
	erb :joke

end

get '/auth' do
	redirect to('https://auth.mxit.com/authorize?response_type=code&client_id=' + 'a1af3b1da78d4d9ba635408cdf35d2d8' + '&redirect_uri=http://127.0.0.1:9393/allow&scope=status/write&state=your_state')
end

get '/allow' do

	response = RestClient.post 'https://' + 'a1af3b1da78d4d9ba635408cdf35d2d8' + ':' + '3720fb8ea26c4cd3a349bb006bb283b6' + '@auth.mxit.com/token','grant_type=authorization_code&code=' + params[:code] + '&redirect_uri=http://127.0.0.1:9393/allow', :content_type => 'application/x-www-form-urlencoded' 

	response2 = RestClient.put 'http://api.mxit.com/user/statusmessage', session[:joke][0..150].to_json, :authorization => 'Bearer ' + JSON.load(response)['access_token'], :content_type => 'application/json'

end