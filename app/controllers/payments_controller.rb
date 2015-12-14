class PaymentsController < ApplicationController

	before_action except: [:show] do
	  user_signed_in?
	end
	before_action :current_user
	before_action :set_payment, only: [:show, :edit, :update]
	before_action only: [:edit, :update] do
		verify_creator_as_current_user(@payment)
	end
	helper_method :formatted_price

	# /POST -> this method is to handle immediate cc payments
	# it is not designed to be used for cc payments that are made
	# only if a criteria (such as the passage of n days) is met
	def new
		@payment = Payment.new
		#@org_connect_key = @org.org_stripe_account.stripe_publishable_key
	end


	def create
		token = params[:stripeToken]

		@payment = @funding_flare.payments.new(
				amount: (params[:payment][:amount]),
				email: current_user.email,
				#!!! card_id was originally intended to 
				#save the card id generated from saving
				# a card that would be charged at a later
				# date (i.e., via the crowdfunding approach);
				# for instant charges, card_id's value is the token
				# generated from Stripe.js or Stripe Checkout
				# in both cases, they are sent as the source paramter
				# in Charge.create
				card_id: params[:stripeToken]
				#!!! ^ see note above about card_id
			)

		@payment.citizen = current_citizen
		@payment.currency = 'usd'
		@payment.organization = @org
		@payment.stripe_customer_id = 'n/a'

		@payment.process!

		if @payment.save
			if @payment.finished?
				redirect_to payment_path(@payment)
			else
				if @payment.status.nil?
					flash[:alert] = "Something went wrong, please try making a contribution again."
				elsif !@payment.status.nil?
					flash[:alert] = @payment.status
				end
				redirect_to organization_flare_funding_path(@org, @funding_flare)
			end
		else
			flash[:alert] = "Something went wrong, please try making a contribution again."
			redirect_to new_payment_path, funding_flare: @funding_flare.slug
		end
	end


	def show

	end


	def edit

	end


	def update
		if @payment.update(about_payment_params)
			redirect_to payment_path(@payment)
		else
			flash[:alert] = "Oops! Looks like there was a small issue saving this. 
			Please try again!"
			render 'edit'
		end
	end

private

	def set_payment
		@payment = Payment.find_by(guid: params[:id])
	end

	def about_payment_params
		params.require(:payment).permit(
			:about
		)
	end

	def payment_params
		params.permit(
			:stripeEmail,
			:stripeToken,
			:id,
			payment: [:amount]
		)
	end

end