class PlayerController < ApplicationController
	def player
		#@requests = Request.all
		@requests = Request.order(sort_column + ' ' + sort_direction)
		@url = params[:url]
	end

	def play
		print "hello" * 5
	end

	helper_method :sort_column, :sort_direction

	private
	
	def sort_column
		Request.column_names.include?(params[:sort]) ? params[:sort] : "id"
	end
	
	def sort_direction
		%w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
	end
end
