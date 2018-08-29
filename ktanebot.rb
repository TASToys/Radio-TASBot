#!/usr/bin/env ruby
require 'configatron'
require 'cinch'
require 'cinch/cooldown'
require_relative 'config/configatron/defaults.rb'

class View
	include Cinch::Plugin
	enforce_cooldown

	match "manual"

	def execute(m)
		m.reply "This is Keep Talking and Nobody Explodes to view the manual go to http://bombmanual.com to learn more about the game go to http://keeptalkinggame.com"
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
