require "./app.rb"
run Sinatra::Application
# use Rack::PostBodyContentTypeParser
$stdout.sync = true

require "active_record"
ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"] || "postgres://localhost/prankster")
