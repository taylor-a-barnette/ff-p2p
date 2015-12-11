class Pledge < ActiveRecord::Base

	#MODULES
	has_paper_trail

	#STATE MACHINES
	
	#VALIDATIONS
	before_validation :populate_guid
	validates_uniqueness_of :guid
	validates_numericality_of :amount, greater_than: 499, message: "of pledge must be at least be 5 dollars"
	validates_presence_of :user_id, :pledgable_type, :pledgable_id, :amount, :currency, :guid, :stripe_customer_id, :card_fingerprint, :card_id
	
	#RELATIONS

	belongs_to :user, foreign_key: :user_id, primary_key: :id
	belongs_to :fundable, :polymorphic => true
	belongs_to :stripe_account, foreign_key: :stripe_customer_id, primary_key: :stripe_customer_id
	belongs_to :card, foreign_key: :card_fingerprint, primary_key: :fingerprint
	has_one :payment

	#METHODS

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
		if Pledge.exists?(:guid => guid) == true
			return true
		else
			return false
		end
	end

	def to_param
		self.guid #overwrites to_param method but returning .guid instead of .id for url
	end

	#CLASS METHODS


end