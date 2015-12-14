source 'https://rubygems.org'
ruby '2.1.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.1'
# Use postgresql as the database for Active Record
gem 'pg'
# Use hirefire to turn off worker or web dynos that are not in use, reducing heroku bill
gem "hirefire-resource"
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

#new relic gem
gem 'newrelic_rpm'

# Gem to handle user authentication, authorization, sessions, etc.
gem 'devise'

# Redis gem to offload sidekiq background jobs, etc.
gem 'redis'

#gem 'bootstrap-sass'
gem 'bootstrap-sass', '~> 3.2.0'
#gem for social-media sharing
gem 'social-share-button'
#gem 'bootsy' for WYSIWYG
gem 'bootsy'
# gem for pagination
gem 'kaminari'
# gem for nested comments
gem 'closure_tree'
#add browser vendor prefixes automatically.
gem 'autoprefixer-rails'
# Use jquery as the JavaScript library
gem 'jquery-rails'
#jquery-turbolinks pulls the jquery.turbolinks library into your project 
	# and will trigger ready() when Turbolinks triggers the page:load event
		# 	meant to restore functionality of some libraries
gem 'jquery-turbolinks'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

#AASM state machine for skimming appeals, tracking transactions, etc
gem 'aasm'

#Sidekiq for background workers
gem 'sidekiq'

#Clockwork to schedule and execute tasks
gem 'clockwork'


# Sidetiq + Dependencies for Sidetiq

# Sidetiq provides a simple API for defining recurring workers for Sidekiq
gem 'sidetiq'

# Ruby Date Recurrence Library - Allows easy creation of recurrence rules and fast querying
gem 'ice_cube'

# provides a simple and natural way to build fault-tolerant concurrent programs in Ruby
gem 'celluloid'

# provides tagging functionality
gem 'acts-as-taggable-on', '~> 3.4'

#paper_trail gem to track life-cycle of payments
gem 'paper_trail', '~> 4.0.0'

#Figaro to handle environment variables
gem "figaro"

#Unicorn webserver as a replacement for WEBrick
gem 'unicorn'

#Abort requests that are taking too long; a subclass of Rack::Timeout::Error is raised
gem "rack-timeout"

#STRIPE payment gem
gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'

#stripe_event provides an interface for handling Stripe events
gem 'stripe_event'

#gem uses the OmniAuth OAuth abstraction library to allow you to connect to 
 #bytgov orgs' Stripe accounts by sending them to /auth/stripe_connect
gem 'omniauth-stripe-connect', '>= 2.4.0'

#Mandrill gem to access Mandrill's API
gem 'mandrill-api'

#Searchkick for search, based on ElasticSearch
gem 'searchkick'

#Pry and pry-related gems
	gem 'pry'
	# use pry-rails instead of copying the initializer to every rails project. 
	# this is a small gem which causes rails console to open pry
	gem 'pry-rails'

group :doc do
	# bundle exec rake doc:rails generates the API under doc/api.
	gem 'sdoc', '~> 0.4.0'
end

group :development do
# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
	gem 'spring'
	gem 'quiet_assets'
end

group :production do
	gem 'rails_12factor'
end

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

