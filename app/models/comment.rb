class Comment < ActiveRecord::Base
	acts_as_tree order: 'created_at DESC'
	#MODULES

	
	#VALIDATIONS
	#validates_presence_of :author, :body

	#RELATIONS

	belongs_to :commentable, polymorphic: true

	#relationship w/ citizen
	belongs_to :user


	#INSTANCE METHODS

	#CLASS METHODS

end
