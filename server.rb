libpath = File.join(File.expand_path(File.dirname(__FILE__)), 'lib')
$LOAD_PATH.unshift(libpath) unless $LOAD_PATH.include?(libpath)
dotpath = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(dotpath) unless $LOAD_PATH.include?(dotpath)

require 'auth/my/stores'
require 'auth/my/stores/index'
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
helpers AuthMyStores

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

get '/auth/my/stores' do
  event = {
    'requestContext' => {
      'authorizer' => {
        'claims' => {
          'cognito:username' => ENV['INDY_AUTH_USERNAME']
        }
      }
    }
  }
  auth_my_stores(event)
end
