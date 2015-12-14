class Blog < ActiveRecord::Base

	#acts_as_taggable

	# kaminari defaults
	default_scope {order(created_at: :desc)}
	paginates_per 15

	#MODULES

	include Sluggable

	sluggable_column :title

	#VALIDATIONS

	validates :title, presence: true, length: { minimum: 6 }
	validates :body, presence: true, allow_blank: false
	validates_length_of :title, on: :create, within: 6..150

	#RELATIONS

	#relationships for citizen, who owns appeal
	belongs_to :user

	# relationship with comments
	has_many :comments, as: :commentable, dependent: :destroy, dependent: :destroy

	#INSTANCE METHODS

	def admin_response
		self.comments.each
	end

	#CLASS METHODS

end


