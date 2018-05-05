#!/usr/bin/env ruby
require 'configatron'
require 'cinch'
require 'sqlite3'
require 'video_info'
require_relative 'config/configatron/defaults.rb'

VideoInfo.provider_api_keys = { youtube: configatron.yt.api }


class Play
	include Cinch::Plugin

	match "play"

	def execute(m)
		contents = m.message
		m.reply "#{m.user.nick}, #{contents}"
	end
end

bot = Cinch::Bot.new do
	configure do |c|
		c.server = "irc.chat.twitch.tv"
		c.password = configatron.twitch.oauth
		c.channels = [configatron.twitch.chan]
		c.plugins.plugins = [Play]
	end

end

bot.start
