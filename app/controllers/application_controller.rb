class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception
	def channel_live
		channelin = RestClient.get "https://api.twitch.tv/helix/streams?user_id=#{configatron.twitch.channel}", {:'Client-ID' => configatron.twitch.clientid}
		islive = Oj.load(channelin).fetch('data').first
		if islive == nil
			@offline = true
		else
			@offline = false
		end
	end
end
