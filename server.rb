libpath = File.join(File.expand_path(File.dirname(__FILE__)), 'lib')
$LOAD_PATH.unshift(libpath) unless $LOAD_PATH.include?(libpath)
dotpath = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(dotpath) unless $LOAD_PATH.include?(dotpath)

require 'sinatra'
require 'stores'
require 'offers'
require 'index'

helpers Stores
helpers Offers

get '/stores' do
  stores_index(params['name'])
end

get '/offers' do
  offers
end
