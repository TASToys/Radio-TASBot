#!/usr/bin/env ruby
require 'configatron'
require 'cinch'
require 'cinch/commands'
require 'sequel'
require 'pg'
require 'video_info'
require 'rest-client'
require 'oj'
require_relative 'config/configatron/defaults.rb'

VideoInfo.provider_api_keys = { youtube: configatron.yt.api }


class Request
	include Cinch::Plugin
	include Cinch::Commands

	command :request, {arg1: :string},
		summary: "Request music with a youtube url.",
		description: %{
		use !request with a youtube url
		}
	
	def request(m,arg1)

		db = Sequel.connect("postgres://#{configatron.sql.user}:#{configatron.sql.pass}@localhost:5432/radio-tasbot")
		requests = db.from(:requests)
		video = VideoInfo.new(arg1)
		linkvid = arg1
		linkuser = m.user.nick
		linktime = Time.now.to_s
		linkupdt = Time.now.to_s
		userreqs = requests.where(twitchname: linkuser)
		counts = userreqs.count 
		if counts >= 2
			m.reply "#{linkuser}, You've already requested two songs please wait for one to be played before trying again. View the queue at radiotasbot.com/queue"
		else
			m.reply "#{m.user.nick}, your video \"#{video.title}\" - \[#{video.author}\] has been added to the queue."
			requests.insert(songurl: linkvid, twitchname: linkuser, created_at: linktime, updated_at: linkupdt) 
		end
	end
end

bot = Cinch::Bot.new do
	configure do |c|
		c.server = "irc.chat.twitch.tv"
		c.password = configatron.twitch.oauth
		c.channels = [configatron.twitch.irc]
		c.plugins.plugins = [Request]
		c.user = configatron.irc.nick
		c.nick = configatron.irc.nick
	end

end

bot.start
