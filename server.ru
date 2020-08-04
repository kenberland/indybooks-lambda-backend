libpath = File.join(File.expand_path(File.dirname(__FILE__)), 'lib')
$LOAD_PATH.unshift(libpath) unless $LOAD_PATH.include?(libpath)

require 'action'

class ToyLambdaSever
    def call(env)
        req = Rack::Request.new(env)
        case req.path_info
        when /stores/
            run Action.new(
                           [200, {"Content-Type" => "text/html"}, ["Hello World!"]])
        else
            [404, {"Content-Type" => "text/html"}, ["I'm Lost!"]]
        end
    end
end

run ToyLambdaSever.new
