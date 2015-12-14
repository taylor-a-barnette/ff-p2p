class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable

	#MODULES
	#include Sluggable
	#sluggable_column :username

	#RELATIONSHIPS
	has_many :blogs
	has_many :pledges
	has_many :cards
	# relationship with comments
	has_many :comments, as: :commentable, dependent: :destroy

	#VALIDATIONS
	validates :email, presence: true#, uniqueness: true
	validates_uniqueness_of :email

	#INSTANCE METHODS

	def check_if_duplicate_card(stripe_token)
		if Rails.env.production?
			fingerprint = Stripe::Token.retrieve(stripe_token).try(:card).try(:fingerprint)
			unless self.cards.find_by(fingerprint: fingerprint)
				#if token has no card attached to it, will not return fingerprint
				#this means that self.cards.find_by will return nothing, even if
				#fingerprint exists on Stripe's database
				return true
			else
				return self.cards.find_by(fingerprint: fingerprint)
			end
		end
	end

	def active_for_authentication?
		super && approved?
	end

	def inactive_message
		if !approved?
			:not_approved
		else
			super
		end
	end

	def blogs_20
		return self.blogs.limit(20)
	end

	#CLASS METHODS
	def self.return_unapproved_users
		@users = User.where(
			"approved = ?",
			"false"
			)
		return @users
	end

end
