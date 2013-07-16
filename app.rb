require 'sinatra'
require 'json'
require 'firebase'
require 'nestful'
require 'dotenv'
require_relative 'lib/iamchucknorris.rb'

enable :sessions

configure do
	Dotenv.load if settings.development?
	Firebase.base_uri = "https://glio-mxit-users.firebaseio.com/#{ENV['MXIT_APP_NAME']}/"
end

get '/' do
	create_user unless get_user
	@joke = JSON.load(Nestful.get('http://api.icndb.com/jokes/random?exclude=[explicit,nerdy]').body)["value"]["joke"]
	@mixup_ad = Nestful.get("http://serve.mixup.hapnic.com/#{ENV['MXIT_APP_NAME']}").body
	session[:joke] = @joke
	erb :joke
end

helpers do
	def get_user
		mxit_user = MxitUser.new(request.env)
		data = Firebase.get(mxit_user.user_id).response.body
		data == "null" ? nil : data
	end
	def create_user
		mxit_user = MxitUser.new(request.env)
		Firebase.set(mxit_user.user_id, {:date_joined => Time.now})
	end
end