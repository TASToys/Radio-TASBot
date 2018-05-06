#!/usr/bin/env ruby
require 'configatron'
require 'cinch'
require 'cinch/commands'
require 'sqlite3'
require 'video_info'
require_relative 'config/configatron/defaults.rb'

VideoInfo.provider_api_keys = { youtube: configatron.yt.api }

class Request
	include Cinch::Plugin
	include Cinch::Commands

	command :request, {arg1: :string},
		summery: "Request music with a youtube url."
	
	def request(m,arg1)

		@db = SQLite3::Database.open 'db/development.sqlite3'
		video = VideoInfo.new(arg1)
		linkvid = arg1
		linkuser = m.user.nick
		linktime = Time.now.to_s
		linkupdt = Time.now.to_s
		m.reply "#{m.user.nick}, your video \"#{video.title}\" has been added to the queue."
		@db.execute("INSERT INTO requests (songurl, twitchname, created_at, updated_at) VALUES (?,?,?,?)", [linkvid, linkuser, linktime, linkupdt])
		@db.close
	end
end

bot = Cinch::Bot.new do
	configure do |c|
		c.server = "irc.chat.twitch.tv"
		c.password = configatron.twitch.oauth
		c.channels = [configatron.twitch.chan]
		c.plugins.plugins = [Request]
	end

end

bot.start
