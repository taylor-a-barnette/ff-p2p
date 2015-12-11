class Card < ActiveRecord::Base

	#MODULES

	#STATE MACHINES
	
	#VALIDATIONS
	validates_uniqueness_of :fingerprint, scope: :user_slug
	validates_uniqueness_of :card_id
	validates_presence_of :user_id, :fingerprint, :card_id, :last4, :brand

	belongs_to :user
	has_many :pledges, foreign_key: :card_fingerprint, primary_key: :fingerprint

	#METHODS

	def new_card(stripe_token, stripe_customer_id)
		if Rails.env.production?
			begin
				customer = Stripe::Customer.retrieve(stripe_customer_id)
				card = customer.sources.create({:source => stripe_token})

				self.card_id = card.id
				self.last4 = card.last4
				self.fingerprint = card.fingerprint
				self.brand = card.brand
				save_card = self
				if save_card.save
					return save_card
				else
					return save_card.errors.full_messages
				end
			rescue Stripe::CardError => e
				return e.message
			end
		end
	end

	#CLASS METHODS

end