class QueueController < ApplicationController
	def queue
		@requests = Request.all
	end
end
