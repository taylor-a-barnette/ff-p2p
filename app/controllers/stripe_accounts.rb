class StripeAccountsController < ApplicationController
	
	before_action :current_user
	before_action :require_user

	def new
		if !current_citizen.stripe_account.nil?
			flash[:alert] = "You already have a card saved. You can edit below."
			redirect_to edit_stripe_account_path
		end
	end

	def create

		if Rails.env.production?
			Stripe.api_key = Rails.configuration.stripe[:secret_key]

			token = params[:stripeToken]

			@stripe_id = current_citizen.create_stripe_id_citizen(token) #method found in citizen.rb

			if @stripe_id == true

				target_bytgov = current_citizen.activate_bytgov(session[:bytgov])
				@bytgov = Bytgov.find(session[:bytgov]).capture_today #marks activiation of bytgov
				#for processing purposes

				if session[:invitation]
					
					@invitation ||= Invitation.find(session[:invitation]) if session[:invitation]

					@invitation.update_attribute(:taken, true)

					session[:invitation] = nil

				end

				session[:bytgov] = nil #clears the session hash
			

				flash[:alert] = "Your card information has been securely captured. Thank you!"
				
				if !target_bytgov.nil?
        			redirect_to bytgov_path(target_bytgov)
        		else
        			redirect_to root
        		end

			else

				flash[:alert] = current_citizen.stripe_account.status
				render :new

    		end

        end

	end
=begin
	def edit

	end

	def update

		if Rails.env.production?
			Stripe.api_key = Rails.configuration.stripe[:secret_key]

			token = params[:stripeToken]

			@stripe_account = current_citizen.stripe_account

			if @stripe_account.update(stripe_customer_id: token)

				flash[:alert] = "Your card information has been securely captured. Thank you!"
        		redirect_to root

			else

				flash[:alert] = current_citizen.stripe_account.status
				render :edit

    		end

        end

	end
=end

	private

	def stripe_account_params
		params.require(:stripe_account).permit(
			:stripeToken
			)
	end


end