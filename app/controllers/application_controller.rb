class ApplicationController < ActionController::Base
	protect_from_forgery prepend: true
	@stream = nil


=begin
	client = Twitch::Client.new client_id: "#{configatron.twitch.clientid}"
	inchan = client.get_streams({user_id: configatron.twitch.channel}).data
	if inchan.empty? == true
		@stream = "offline"
		print "offline \n" * 5
	elsif inchan.empty? == false
		@stream = "online"
		print "online \n" * 5
	end
=end
end
