class UsersController < ApplicationController

	before_action :require_admin, only: [:awaiting_verification, :approve_org]
	before_action :current_user
	before_action :require_user
	before_action :set_user, except: [:index, :approve_org]
	before_action :require_specific_user, only: [:payments_and_pledges, :show]
	helper_method :formatted_price
	
	#before_action :user_params_no_hash

	#def index
	#
	#end

	#def awaiting_verification
	#	@user = User.return_unapproved_users
	#end

	def show

	end


	def payments_and_pledges
		#only for citizens
	end

	#new and create taken care of by users/registrations_controller.rb
	#edit, update, destroy for ALL USERS also taken care of by users/registrations_controller.rb
	#edit and update for users with organization details handled by organizations_controller.rb

	private

		def set_user
			@user = User.find_by(slug: params[:id])
		end

		def require_specific_user
			if current_user != @user && !current_user.admin?
				flash[:notice] = "It looks like you aren't the owner of that."
				redirect_to root_path
			else
				flash[:notice] = "You aren't signed-in."
				redirect_to root_path
			end
		end
end
