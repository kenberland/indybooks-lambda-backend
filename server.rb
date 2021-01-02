libpath = File.join(File.expand_path(File.dirname(__FILE__)), 'lib')
$LOAD_PATH.unshift(libpath) unless $LOAD_PATH.include?(libpath)
dotpath = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(dotpath) unless $LOAD_PATH.include?(dotpath)

require 'auth/piles_post'
require 'auth/piles_post/index'
require 'auth/my/stores'
require 'auth/my/stores/index'
require 'auth/inventory/store/isbn'
require 'auth/inventory/store/isbn/index'
require 'auth/inventory/store/isbn/put'
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
helpers AuthInventoryStoreIsbn


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
    'body' =>  request.body.read
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

get '/auth/inventory/store/*/isbn/*' do
  event = {
    'pathParameters' => {
      'proxy' =>  "store/#{params[:splat][0]}/isbn/#{params[:splat][1]}"
    }
  }
  auth_inventory_store_isbn(event)
end

put '/auth/inventory/store/*/isbn/*' do
  event = {
    'pathParameters' => {
      'proxy' =>  "store/#{params[:splat][0]}/isbn/#{params[:splat][1]}"
    },
    'body' =>  request.body.read
  }
  auth_inventory_store_isbn_put(event)
end

get '/auth/my/piles' do
  event = {
    'requestContext' => {
      'authorizer' => {
        'claims' => {
          'cognito:username' => ENV['INDY_AUTH_USERNAME']
        }
      }
    }
  }
  auth_my_piles(event)
end

post '/auth/piles' do
  event = {
    'requestContext' => {
      'authorizer' => {
        'claims' => {
          'cognito:username' => ENV['INDY_AUTH_USERNAME']
        }
      }
    },
    'body' =>  request.body.read
  }
  auth_piles_post(event)
end

put '/auth/pile/*' do
  event = {
    'pathParameters' => {
      'proxy' =>  params[:splat][0]
    },
    'body' =>  request.body.read
  }
  auth_pile_put(event)
end

delete '/auth/pile/*' do
  event = {
    'pathParameters' => {
      'proxy' =>  params[:splat][0]}
  }
  auth_pile_delete(event)
end
