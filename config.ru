require `./hello`
run Sinatra::Application
use Rack::PostBodyContentTypeParser
$stdout.sync = true
