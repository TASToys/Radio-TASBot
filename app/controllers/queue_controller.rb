class QueueController < ApplicationController
	def queue
		@requests = Request.all.order(sort_column + " " + sort_direction)
	end

	private
	
	def sort_column
		Request.column_names.include?(params[:sort]) ? params[:sort] : "name"
	end
	
	def sort_direction
		%w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
	end
end
