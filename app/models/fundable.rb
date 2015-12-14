class Fundable < ActiveRecord::Base

	# acts_as_taggable
	default_scope {order(proposal_published_date: :desc, created_at: :desc)}

	#MODULES
	include AASM
	include Sluggable
	sluggable_column :title

	#STATE MACHINE
	aasm column: 'state' do 
		state :in_dev, initial: true #when user is putting project together
		state :published #when user has published
		state :success #user's project is funded
		state :failure #user's project failed to get funding by deadline
		state :paid #payments have been run on proposal

		event :published, after: :establish_time_published do
			transitions from: :in_dev, to: :published
		end

		event :success do
			transitions from: :published, to: :success
		end

		event :failure do
			transitions from: :published, to: :failure
		end

		event :paid do
			transitions from: :success, to: :paid
		end

	end

	#VALIDATIONS
	validates_presence_of(
		 :title,
		 :about,
		 :summary,
		 :risks_challenges,
		 :duration,
		 :funding_goal
		)

	validates_length_of :title, on: :create, within: 8..100
	#validates_length_of :days_open, on: :create, within: 1..40
	validates_inclusion_of :existing_program, in: [true, false]

	#RELATIONS
	has_many :appeals_to_proposals
	has_many :appeals, :through => :appeals_to_proposals

	belongs_to :organization, foreign_key: :org_slug, primary_key: :slug
	has_many :funding_tiers, foreign_key: :proposal_slug, primary_key: :slug, dependent: :destroy
	has_many :comments, as: :commentable, dependent: :destroy, dependent: :destroy
	
	#polymorphic relationship with payments
	has_many :payments, as: :paymentable#, dependent: :destroy, dependent: :destroy

	#relationship with pledges
	has_many :pledges, foreign_key: :proposal_slug, primary_key: :slug, dependent: :destroy

	#INSTANCE METHODS

=begin
#setter method
	def action_start_date=(val)
		if val.present?
			@a = Date.strptime(val, "%m/%d/%Y")
			@a.strftime("%Y/%m/%d")
			val = @a
			return
		end
	end
=end
	def relation_with_appeal?(appeal_id)
		if self.appeals.where(id: appeal_id).exists?
			return true
		else
			return false
		end
	end

	def establish_time_published
		self.update(proposal_published_date: Time.now)
	end

	def time_left
		time_left = (self.proposal_published_date + self.days_open.days) - Time.now
		return (time_left / 1.day.seconds).to_i
	end

	def determine_if_successful
		if self.time_left <= 0
			#check to see if funding amounts add up to target
			total_amount = self.count_pledge_amounts
			success = false
			self.funding_tiers.each do |n|
				if total_amount >= n.target_amount
					success = true
				end
			end

			if success == true
				self.success!
				self.update_attributes(final_amount: total_amount)
				OrganizationMailer.delay.proposal_funded_org(self.organization.user.id, self.id)
				CitizenMailer.delay.proposal_funded_bytizen(self.id)
				AdminMailer.delay.proposal_succeeded(nil, self.id) #nil bc defaults ok per Rails documentation
			elsif success == false
				self.failure!
				OrganizationMailer.delay.proposal_failed_org(self.organization.user.id, self.id)
				CitizenMailer.delay.proposal_failed_bytizen(self.id)
				AdminMailer.delay.proposal_failed(nil, self.id) #nil bc defaults ok per Rails documentation
			end
		end
	end

	def stop_or_support_value(appeals_id)
		val = self.appeals_to_proposals.where("appeal_id = ?", appeals_id).first
		return val.stop_or_support
	end

	def count_pledge_amounts
		pledges = self.pledges
		total_amount = 0
		pledges.each do |n|
			total_amount = total_amount + n.amount
		end
		return total_amount
	end

	def count_number_of_pledges
		return self.pledges.count
		#could also use self.pledges.size, but there are considerations:
		#http://stackoverflow.com/questions/6083219/activerecord-size-vs-count
	end

	def target_amount_count
		if self.funding_tiers.count == 1
			return false
		elsif self.funding_tiers.count > 1
			return true
		end
	end

	def get_lone_amount
		return self.funding_tiers.first.target_amount
	end

	def get_max_target
		@b = Array.new
		self.funding_tiers.each do |n|
			@b << n.target_amount
		end
		return @b.max
	end

	def get_min_target
		if self.funding_tiers.where("min_target = ?", true).exists?
		   return self.funding_tiers.where("min_target = ?", true).first.target_amount
		end
	end

	def charge_bytgov_for_proposal
	#this method is used to take all pledges of a successful proposal
	#and charge the cards associated with the pledge via Stripe
	#the Payment is created here, the charge is made via #process (from payment state machine) 
	#and charge_bytizen_with_card_saved,
	#which resides in payment.rb and handles both successful and failed charge attempts
		if Rails.env.production?

			@pledges = self.pledges

			@pledges.each do |n|				

				@payment = n.build_payment
				@payment.stripe_customer_id = n.stripe_customer_id
				@payment.pledge = n
				@payment.amount = n.amount
				@payment.currency = n.currency
				@payment.email = n.citizen.user.email
				@payment.citizen = n.citizen
				@payment.proposal = self
				@payment.organization = self.organization
				@payment.card_id = n.card_id

				@payment.process!
				# ^ this line handles charges made through Stripe along with emails 
				# to bytizens detailing of the charge's failure or success
			end

			self.paid! #<= DON"T FORGET TODO!
		end
	end

	#CLASS METHODS

	def self.all_but_in_dev
		return Proposal.where( "state != ?", "in_dev")
	end

	def self.proposals_to_be_measured
	#this method pulls all proposals that published and should be assessed to 
	#see if they have ended and if they have met a funding goal
		return Proposal.where(:final_amount => nil, :state => "published")
	end

	def self.success_but_not_paid
		return Proposal.where(:state => "success")
	end

end