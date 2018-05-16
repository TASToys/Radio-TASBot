# Radio-TASBot
____
Welcome to Radio TASBot:

* Ruby version: 2.5.1

* System dependencies: 
  - PostgreSQL 
  - Youtube API key
  - Twitch ClientID
  - Twitch Oauth

To get a youtube api key follow this [guide](https://developers.google.com/youtube/registering_an_application).
To get a twitch ClientID follow this [guide](https://dev.twitch.tv/docs/authentication/#registration).
To get a twitch oauth go to this [page](https://twitchapps.com/tmi/)

* Configuration:
  - run `rails g configatron:install`
  - `cp config/configatron/example.defaults.rb config/configatron/defaults.rb`
  - Put your youtube api key and twitch client id and oauth into the defaults file
  - Specify the channelid needed for twitch for offline mode(still working on that)
  - Add the irc version of the channel to the config i.e. `#kappa`
  - Provide your credentials for your SQL database

* Database creation
  * create a database called radio-tasbot

* Database initialization
  * `rake db:migrate`

* Services (job queues, cache servers, search engines, etc.)
  * For the ircbots i recommend using pm2 to keep them running
  * `npm install pm2 -g`
  * `pm2 start musicbot.rb`
  * `pm2 start queuebot.rb`

* Deployment instructions
  * `bundle install`
  * `rails s -p 80`

* Passenger deployment with Apache
  * [Passenger set-up instructions](https://www.phusionpassenger.com/library/config/apache/intro.html)
* Passenger deployment with Ningx
  * [Passenger set-up instructions](https://www.phusionpassenger.com/library/config/nginx/intro.html)
				       
