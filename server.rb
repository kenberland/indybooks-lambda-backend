libpath = File.join(File.expand_path(File.dirname(__FILE__)), 'lib')
$LOAD_PATH.unshift(libpath) unless $LOAD_PATH.include?(libpath)
dotpath = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(dotpath) unless $LOAD_PATH.include?(dotpath)

require 'sinatra'
require 'stores'
require 'offers'
require 'offers/index'
require 'stores/index'

helpers Stores
helpers Offers

get '/stores/lat/*/long/*' do
  event = {
    'pathParameters' => {
      'proxy' =>  "stores/lat/#{params[:splat][0]}/long/#{params[:splat][1]}"
    }
  }
  stores(event)
end

get '/offers/isbn/*/vendors/*' do
  event = {
    'pathParameters' => {
      'proxy' =>  "isbn/#{params[:splat][0]}/vendors/#{params[:splat][1]}"
    }
  }
  offers(event)
end
