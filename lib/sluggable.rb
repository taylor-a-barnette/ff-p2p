module Sluggable

	extend ActiveSupport::Concern

	included do 
		after_validation :generate_slug!
		class_attribute :slug_column
	end

	def to_param
		self.slug #overwrites to_param method but returning slug instead of .id for url
	end

	def generate_slug!

		#hooks into the lifecycle of object after validation but before save
		#is the self.class here: (self.class.slug_column.to_sym)) necessary? don't think so...
		the_slug = to_slug(self.send(self.class.slug_column.to_sym)) #grab the title
		obj = self.class.find_by slug: the_slug #look for a slug that matches the title
		count = 2

		if !!obj == false #if no slug matches the title, the title is unique and
			self.slug = the_slug.downcase #it can be assigned to the slug attribute of the object
		elsif !!obj == true #if the slug matches the title, the title is not unique
			while obj && obj != self #while the user exists and is not equal to the object
				the_slug = the_slug + "-" + count.to_s #execute the count, add to the slug
				obj = self.class.find_by slug: the_slug #find the attribute's value
				if !!obj == false #if the slug is not found, then the value is now unique
					self.slug = to_slug(self.send(self.class.slug_column.to_sym)) + "-" + (count.to_s).downcase #and can be assigned
					break
				elsif !!obj == true #otherwise, keep the process going until user == false
					count += 1
				end
			end
		end

	end

	def to_slug(name)
		str = name.strip #strips out whitespace
		str.gsub! /\s*[^A-Za-z0-9]\s*/,'-' #takes out all characters but those between brackets, and inserts '-'
		str.gsub! /-+/, '-' #removes + and - signs
		str #returns string
	end

	module ClassMethods

		def sluggable_column(col_name)
			self.slug_column = col_name
		end
	end

end