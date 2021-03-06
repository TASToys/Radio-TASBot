#!/usr/bin/env ruby
require 'configatron'
require 'cinch'
require 'cinch/cooldown'
require_relative 'config/configatron/defaults.rb'

class View
	include Cinch::Plugin
	enforce_cooldown

	match "queue"

	def execute(m)
		m.reply "To View the queue go to http://radiotasbot.com/queue"
	end
end

bot = Cinch::Bot.new do
	configure do |c|
		c.shared[:cooldown] = { :config => { dwangoac: { global: 20, user: 30 } } }
		c.server = "irc.chat.twitch.tv"
		c.password = configatron.twitch.oauth
		c.channels = [configatron.twitch.irc]
		c.plugins.plugins = [View]
	end

end

bot.start
