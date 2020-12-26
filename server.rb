libpath = File.join(File.expand_path(File.dirname(__FILE__)), 'lib')
$LOAD_PATH.unshift(libpath) unless $LOAD_PATH.include?(libpath)
dotpath = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(dotpath) unless $LOAD_PATH.include?(dotpath)

require 'offers'
require 'offers/index'
require 'purchases'
require 'purchases/index'
require 'purchases_post'
require 'purchases_post/index'
require 'sinatra'
require 'stores'
require 'stores/index'

helpers Stores
helpers Offers
helpers Purchases
helpers PurchasesPost

get '/stores/lat/*/long/*' do
  event = {
    'pathParameters' => {
      'proxy' =>  "lat/#{params[:splat][0]}/long/#{params[:splat][1]}"
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

post '/purchases' do
  event = {
    'pathParameters' => {
      'post_body' =>  request.body.read
    }
  }
  purchases_post(event)
end

get '/purchases/customer_uuid/*' do
  event = {
    'pathParameters' => {
      'proxy' =>  "customer_uuid/#{params[:splat][0]}"
    }
  }
  purchases(event)
end
