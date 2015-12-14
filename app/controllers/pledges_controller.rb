class PledgesController < ApplicationController

	before_action :require_citizen, except: [:show]
	before_action :set_proposal, except: [:destroy]
	#before_action :set_appeal, only: [:new, :create]
	before_action :current_user, except: [:show]
	before_action :current_citizen, except: [:show]
	before_action :set_pledge, only: [:show, :destroy, :update, :edit, :update_about_pledge, :edit_about_pledge]
	before_action :amount_to_integer, only: [:create]
	before_action :verify_current_user_is_creator, only: [:edit, :update, :destroy, :update_about_pledge, :edit_about_pledge]
	helper_method :formatted_price
	before_action :set_appeal, only: [:create_appeal_pledge, :new_appeal_pledge]
	before_action only: [:edit, :update, :destroy, :update_about_pledge, :edit_about_pledge] do
		verify_creator_as_current_bytizen(@pledge)
	end

	def convert_pledge_to_contribution
		@pledge = Pledge.find(params[:pledge_id])
		if @pledge.update(proposal_slug: params[:proposal_id])
			flash[:notice] = "Your pledge
					has been registered. If the proposal 
					reaches at least its minimum funding target, 
					your card will be charged and a receipt will be
					emailed to you. Thank you!"
			redirect_to pledge_path(@pledge)
		else
			flash[:alert] = "Something went wrong. Please try again."
		end
	end

	def new
		if @proposal.published?
			@pledge = Pledge.new
		else
			flash[:notice] = "Sorry, but this proposal cannot be funded right now,
			probably because its funding time has ended."
			redirect_to proposal_path(@proposal)
		end
	end

	def create
		if Rails.env.production?
			Stripe.api_key = Rails.configuration.stripe[:secret_key]
			token = params[:stripeToken]

			#if user does not have stripe_account association
			if @citizen.stripe_account.nil? && current_user.bytizen?
				@stripe_id = @citizen.create_customer_and_stripe_account
				#create_customer_and_stripe_account is found in Citizen.rb, and
				#if this method does not return true, there is an error
				#otherwise, progress to creating pledge
				if @stripe_id != true
					flash[:alert] = @stripe_id.to_s #returns e.messages
					render :new
				end
			end

			@card = current_user.check_if_duplicate_card(token)	

			if @card == true
				@card = current_user.cards.new
				@card = @card.new_card(token, @citizen.stripe_account.stripe_customer_id)
				if !Card.exists?(@card)
					flash[:alert] = @card #returns error messages
					redirect_to new_proposal_pledge_path(@proposal)
				end	
			end

			if Card.exists?(@card)
				@pledge = @card.pledges.new(pledge_params)
				@pledge.card_fingerprint = @card.fingerprint
				@pledge.card_id = @card.card_id
				@pledge.citizen = @citizen
				@pledge.proposal = @proposal
				#@pledge.stop_or_support = @proposal.appeals_to_proposals.stop_or_support
				@pledge.stripe_customer_id = @citizen.stripe_account.stripe_customer_id
				#guid generated and saved on model side
				@pledge.currency = 'usd'
				if @pledge.save
					flash[:notice] = "Congratulations! Your card information has been securely 
					captured and your pledge amount
					has been registered. If the proposal 
					reaches at least its minimum target, 
					your card will be charged and a receipt will be
					emailed to you. Thank you!"
					#send email?
					redirect_to edit_about_pledge_pledge_path(@pledge)
				else
					render :new
				end
			else
				flash[:alert] = "something went wrong - please try again"
				redirect_to new_proposal_pledge_path(@proposal)
			end
		end
	end

	def show

	end

	def new_appeal_pledge
		@bytgov = Bytgov.find_by(slug: params[:bytgov_id])
		@pledge = Pledge.new
	end

	def create_appeal_pledge 
		#creates a pledge with no relation to a proposal; can be applied to a proposal later
		if Rails.env.production?
			Stripe.api_key = Rails.configuration.stripe[:secret_key]
			token = params[:stripeToken]

			#if user does not have stripe_account association
			if @citizen.stripe_account.nil? && current_user.bytizen?
				@stripe_id = @citizen.create_customer_and_stripe_account
				#create_customer_and_stripe_account is found in Citizen.rb, and
				#if this method does not return true, there is an error
				#otherwise, progress to creating pledge
				if @stripe_id != true
					flash[:alert] = @stripe_id.to_s #returns e.messages
					render :new
				end
			end

			@card = current_user.check_if_duplicate_card(token)	

			if @card == true
				@card = current_user.cards.new
				@card = @card.new_card(token, @citizen.stripe_account.stripe_customer_id)
				if !Card.exists?(@card)
					flash[:alert] = @card #returns error messages
					redirect_to new_proposal_pledge_path(@proposal)
				end	
			end

			if Card.exists?(@card)
				@pledge = @card.pledges.new(pledge_params)
				@pledge.card_fingerprint = @card.fingerprint
				@pledge.card_id = @card.card_id
				@pledge.citizen = @citizen
				@pledge.appeal = @appeal
				@pledge.proposal_slug = 'pending'
				@pledge.stripe_customer_id = @citizen.stripe_account.stripe_customer_id
				@pledge.stop_or_support = params[:stop_or_support]
				#guid generated and saved on model side
				@pledge.currency = 'usd'
				if @pledge.save
					flash[:notice] = "Your card information has been securely 
					captured and your pledge amount
					has been registered. Remember, if an organization makes a proposal you like,
					you should apply your pledge to that proposal."
					#send email?
					redirect_to pledge_path(@pledge)
				else
					render :new_appeal_pledge
				end
			else
				flash[:alert] = "something went wrong - please try again"
				redirect_to bytgov_appeal_path(@appeal.bytgov, @appeal)
			end
		end
	end

	def edit

	end

	def edit_about_pledge

	end

	def update_about_pledge
		if @pledge.update(about: params[:pledge][:about])
				flash[:notice] = "You added or updated information about your pledge."
				redirect_to pledge_path(@pledge)
		else
			flash[:alert] = "Update error. Please try again."
			render 'edit_about_pledge'
		end
	end

	def update
		if Rails.env.production?
			Stripe.api_key = Rails.configuration.stripe[:secret_key]
			token = params[:stripeToken]

			@card = current_user.check_if_duplicate_card(token)	

			if @card == true
				@card = current_user.cards.new
				@card = @card.new_card(token, @citizen.stripe_account.stripe_customer_id)
				if !Card.exists?(@card)
					flash[:alert] = @card #returns error messages
					render :edit
				end	
			end

			if Card.exists?(@card)
				if @pledge.update(card_id: @card.card_id)
					flash[:notice] = "Your card information has been securely 
					updated. Thank you!"
					#send email?
					redirect_to proposal_path(@proposal)
				end
			else
				flash[:alert] = "There was an error in capturing your new card information.
				Please try again."
				render :edit
			end
		end
	end

	def destroy
		if @pledge.proposal.published?
			if @pledge.destroy
				flash[:notice] = "You deleted a pledge."
				redirect_to payments_and_pledges_user_path(current_user)
			else
				flash[:alert] = "Something went wrong and your pledge was not deleted. Please try again."
				render :edit
			end
		else
			flash[:notice] = "You cannot delete this pledge. The proposal has already closed."
			redirect_to payments_and_pledges_user_path(current_user)
		end
	end

private
#/appeals/:appeal_id/proposals/:proposal_id/pledges/new(.:format)
	def set_proposal
		@proposal = Proposal.find_by(slug: params[:proposal_id]) #works?
	end

	def set_appeal
		@appeal = Appeal.find_by(slug: params[:appeal_id])
	end

	def set_pledge
		@pledge = Pledge.find_by(guid: params[:id])
	end

	def amount_to_integer
		params[:pledge][:amount] = params[:pledge][:amount].to_i
	end

	def pledge_params
		params.require(:pledge).permit(
			:stripeEmail,
			:stripeToken,
			:amount,
			:about
		)
	end

	def verify_current_user_is_creator
		unless current_user.admin?
			if current_citizen != @pledge.citizen 
				flash[:notice] = "You are unable to edit that pledge."
				redirect_to root_path
			end
		end
	end

end