class Payment < ActiveRecord::Base

	#MODULES
	include AASM

	has_paper_trail

	#STATE MACHINES

	aasm column: 'state' do

		state :pending, initial: true
		state :processing
		state :finished
		state :errored

		event :process, after: :charge_card do #for crowdfunding use :charge_bytizen_with_card_saved
			transitions from: :pending, to: :processing
		end

		event :finish, after: :submit_receipt do
			transitions from: :processing, to: :finished
		end

		event :fail do
			transitions from: :processing, to: :errored
		end
		
	end

	#VALIDATIONS

	before_validation :populate_guid
	validates_uniqueness_of :guid

	#RELATIONS
	belongs_to :user #<= the user who is paying
	belongs_to :fundable, polymorphic: true
	belongs_to :pledge # foreign key is pledge_id

	#METHODS

	def to_param
		self.guid
		#overwrites to_param method but returning .guid instead of .id for url
	end

	private

	def charge_card
		begin
			save!
			charge = Stripe::Charge.create({
				amount: self.amount,
				currency: self.currency,
					#!!! card_id was originally intended to 
					#save the card_id generated from saving
					# a card that would be charged at a later
					# date (as in a crowdfunding approach);
					#for instant charges, card_id is the token
					# generated from Stripe.js or Stripe Checkout
					source: self.card_id,
					#!!! ^ see note above about self.card_id
				description: self.email,
				statement_descriptor: "crowdfunding payment",
				receipt_email: self.email,
				application_fee: (self.amount.to_i)/(20) #assumes 5%
				},

				self.organization.org_stripe_account.stripe_access_key
			)

			balance = Stripe::BalanceTransaction.retrieve(charge.balance_transaction)

			self.update(
				#stripe_id: charge.id,
				charge_id: charge.id
				#card_expiration: Date.new(charge.card.exp_year, charge.card.exp_month, 1),
				#fee_amount: balance.fee
			)

			self.finish!

		rescue Stripe::StripeError => e
			self.update_attributes(status: e.message)
			self.fail!
		end
	end

	def charge_bytizen_with_card_saved
		save!
		begin
			Stripe.api_key = Rails.configuration.stripe[:secret_key]
			#re: token, see => https://stripe.com/docs/connect/shared-customers

			# create the token that will be used to create the customer on the
			# connected account
			token = Stripe::Token.create(
			  {customer: self.stripe_customer_id, card: self.card_id},
			  self.organization.org_stripe_account.stripe_access_key #access key of the connected account
			)

			#create the charge
			charge = Stripe::Charge.create({
				amount: self.amount,
				currency: self.currency,
				source: token.id,
				#card: token.id, <= possibly faulty code in MMP, but probably 
				#interchangeable with source: ... parameter
				description: "BytGov contribution from #{self.email} for #{self.proposal_slug}",
				statement_descriptor: "bytgov payment",
				receipt_email: self.email,
				application_fee: (self.amount.to_i)/(20)
			   },
			   #:stripe_account => self.organization.org_stripe_account.stripe_publishable_key <- this doesn't work despite Stripe documentation
			   self.organization.org_stripe_account.stripe_access_key #<- does work
			)

			#balance = Stripe::BalanceTransaction.retrieve(charge.balance_transaction)

			self.update(

					charge_id: charge.id
				)

			self.finish!

		rescue Stripe::StripeError => e
			self.update_attributes(status: e.message)
			#send email with error
			self.fail!
		end
	end

	def submit_receipt
		@user = self.user
		CitizenMailer.delay.payment_email_citizen(@citizen.id, self.id)
	end

	def populate_guid
		if new_record? && self.guid.nil?
		   self.guid = SecureRandom.uuid().to_s
		   #SecureRandom.random_number(1_000_000_000).to_s(36)
			while check_guid?(self.guid) == true
				self.guid = SecureRandom.uuid().to_s
			end
		end
	end

	def check_guid?(guid)
		if Payment.exists?(:guid => guid) == true
			return true
		else
			return false
		end
	end

end