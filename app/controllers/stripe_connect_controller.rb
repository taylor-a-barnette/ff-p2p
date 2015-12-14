class StripeConnectController < ApplicationController

	before_action do
	  user_signed_in?
	end
	before_action :current_user

	def connect_to_stripe
      if !Rails.env.production? &&  !current_user.stripe_account.nil?
      	flash[:notice] = "You already have a Stripe account on file. Contact us
		 if you think this is an error."
		redirect_to :back
      end
	end

	def create
		if current_user.stripe_account.nil?

			auth_hash = request.env['omniauth.auth']

			@user_stripe_account = current_user.build_org_stripe_account

			@user_stripe_account.stripe_id = auth_hash['uid']
			@user_stripe_account.stripe_access_key = auth_hash['credentials']['token']
			@user_stripe_account.stripe_publishable_key = auth_hash['info']['stripe_publishable_key']
			@user_stripe_account.stripe_refresh_token = auth_hash['credentials']['refresh_token']
			if @user_stripe_account.save
				flash[:success] = "Congratulations! You have successfully created and connected 
				to your Stripe account. You can now securely
				receive contributions. You can track and manage them
				in your Stripe account."
			else
				flash[:alert] = "Something went wrong - you likely entered incorrect 
				information or you already have a Stripe account. Please try again. 
				If this error persists, please contact us. We'll help you work
				through the issue."
			end
		else
			flash[:info] = "You already have a Stripe account on file. Contact us
			if you think this was done in error."
		end
	end

end