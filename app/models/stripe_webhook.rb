class StripeWebhook < ActiveRecord::Base
	validates_uniqueness_of :charge_id
end