class StripeAccount < ActiveRecord::Base

	#MODULES

	#STATE MACHINES
	
	#VALIDATIONS
	before_validation :populate_guid
	validates_uniqueness_of :guid
	validates_presence_of(
		:guid, 
		:stripe_id, 
		:stripe_access_key, 
		:stripe_publishable_key, 
		:stripe_refresh_token
	)

	#RELATIONS

	belongs_to :user

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