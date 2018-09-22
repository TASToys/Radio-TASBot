#!/usr/bin/env ruby
require 'eventmachine'
require 'sequel'
require 'pg'
require 'video_info'
require 'configatron'
require 'websocket-eventmachine-client'
require 'oj'
require 'open-uri'
require 'net/http'
require_relative 'config/configatron/defaults.rb'

VideoInfo.provider_api_keys = { youtube: configatron.yt.api }

db = Sequel.connect("postgres://#{configatron.sql.user}:#{configatron.sql.pass}@localhost:5432/radio-tasbot")

requests = db.from(:requests)
statusfile = ("#{configatron.ice.url}/status-json.xsl")
#statusfile = URI.parse("http://10.20.30.202:9989/status_json.xsl")

EM.run do
	ws = WebSocket::EventMachine::Client.connect(:host => 'irc-ws.chat.twitch.tv', :port => 80, :ssl => false)

	ws.onopen do
		puts "Connected"
		ws.send "CAP REQ :twitch.tv/tags twitch.tv/commands twitch.tv/membership"
		ws.send "PASS #{configatron.twitch.oauth}"
		ws.send "NICK #{configatron.irc.nick}"
		ws.send "JOIN #{configatron.twitch.irc}"

		ws.send "PRIVMSG #{configatron.twitch.irc} :#{configatron.welcome.message}"

		#ws.send "PRIVMSG #mediamagnet :/me whale hello there, Musicbot v2 connected."

	end
	ws.onmessage do |msg, type|
		if msg.include?('PING') == true
			ws.send "PONG :tmi.twitch.tv"

		elsif msg.include?(' PRIVMSG ')
			metadata = msg.split(' ')[0]
			user_msg_arr = msg.split(' ')
			user_msg_arr.shift
			user_msg_arr.shift
			user_msg_arr.shift
			user_msg_arr.shift
			user_msg_arr[0] = user_msg_arr[0].delete_prefix(':')
			user_name = metadata.split(';').keep_if{ |name| name =~ /display-name=([a-zA-Z\d\W]{1,32})/}.last.split('=').last


			if user_msg_arr[0] == '!queue'
				ws.send "PRIVMSG #{configatron.twitch.irc} :To view the Queue please go to http://radiotasbot.com/queue"
			elsif user_msg_arr[0] == '!request'
				if user_msg_arr[-1] == '!request'
					ws.send "PRIVMSG #{configatron.twitch.irc} :To request a song do !request <youtube url>"
				elsif user_msg_arr[-1].include?('youtube')
					video = VideoInfo.new(user_msg_arr[-1])
					linkvid = user_msg_arr[-1]
					linkuser = user_name
					linktime = Time.now.to_s
					linkupdt = Time.now.to_s
					userreqs = requests.where(twitchname: linkuser)
					counts = userreqs.count
					if counts >= 2
						puts metadata
						ws.send "PRIVMSG #{configatron.twitch.irc} :#{user_name}, you've already requested two songs please wait for one to be played before requesting more. To view the queue go to http://radiotasbot.com/queue"
					else
						ws.send "PRIVMSG #{configatron.twitch.irc} :#{user_name}, your video \"#{video.title}\" - \[#{video.author}\] has been added to the queue. To view the queue go to http://radiotasbot.com/queue"
						requests.insert(songurl: linkvid, twitchname: linkuser, created_at: linktime, updated_at: linkupdt)
						puts "#{user_name} added #{video.title} to the queue"
					end
				end
			elsif user_msg_arr[0] == '!playing'
				iceurl = URI.parse("http://#{statusfile}")
				response = Net::HTTP.get_response(iceurl)
				puts response
				iceopen = Oj.load(response.body.to_s)
				ice1 = iceopen.fetch('icestats').fetch('source').fetch('yp_currently_playing')
				ws.send "PRIVMSG #{configatron.twitch.irc} :\"#{ice1}\" is coming through the SNES right now!"
			end
		

		elsif msg.include?(' JOIN ') || msg.include?(' PART ')

		else
			puts msg
		end
	end

	ws.onclose do |code, reason|
		puts "Disconnected with status code: #{code} #{reason}"

	end

	ws.onerror do |error|
		puts "Error: #{error}"

	end

	EventMachine.next_tick do
		puts "tick!"
	end
end
