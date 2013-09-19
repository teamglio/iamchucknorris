require 'dotenv'
require 'firebase'
require 'nestful'
require_relative 'mxit_api.rb'

class RandomJokeBroadcast

	def self.broadcast
		Dotenv.load 
		#users = ['m41162520002', 'm47975403002']

		Firebase.base_uri = "https://glio-mxit-users.firebaseio.com/#{ENV['MXIT_APP_NAME']}/"
		users = JSON.load(Firebase.get('').response.body).keys
		joke = JSON.load(Nestful.get('http://api.icndb.com/jokes/random?exclude=[explicit,nerdy]').body)["value"]["joke"]

		users.each do |user|
			begin
				MxitAPI.send_message(user, joke)
			rescue
				next
			end
		end
	end

end