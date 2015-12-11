
worker_processes 3
#or this if you need change number of worker processes within each dyno, see link:
#http://stackoverflow.com/questions/23171851/what-do-i-set-envweb-concurrency-to-when-using-heroku-and-sidekiq
timeout 15
preload_app true

before_fork do |server, worker|
	Signal.trap 'TERM' do
		puts 'Unicorn master intercepting TERM and sending myself.'
		Process.kill 'QUIT', Process.pid
	end

	defined?(ActiveRecord::Base) and
		ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
	Signal.trap 'TERM' do
		puts 'Unicorn master intercepting TERM and doing nothing.'
	end

	defined?(ActiveRecord::Base) and
		ActiveRecord::Base.establish_connection
end