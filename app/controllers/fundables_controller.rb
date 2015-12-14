class FundablesController < ApplicationController

    include CommentsHelper
	before_action do
	  user_signed_in?
	end
	before_action :current_user
	before_action :set_fundable


	def index

	end


	def show

	end


	def new

	end


	def create

	end


	def edit

	end


	def update

	end


	def destroy

	end

	private

		def set_fundable
			@fundable = Fundable.find_by(slug: params[:id])
			#use find_by to get slug, not find, which looks explicitly for id
		end

		def fundable_params
			params.require(:fundable).permit(
				:title,
				:about,
				:summary,
				:risks_challenges,
				:duration,
				:funding_goal
			)
		end

end