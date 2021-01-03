libpath = File.join(File.expand_path(File.dirname(__FILE__)), 'lib')
$LOAD_PATH.unshift(libpath) unless $LOAD_PATH.include?(libpath)
dotpath = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(dotpath) unless $LOAD_PATH.include?(dotpath)

require 'pry'

require 'lambda/auth/inventory/store/isbn/get'
require 'lambda/auth/inventory/store/isbn/put'
require 'lambda/auth/my/stores/get'
require 'lambda/auth/my/pile/get'
require 'lambda/auth/pile/get'
require 'lambda/auth/pile/post'
require 'lambda/auth/pile/put'
require 'lambda/offers/get'
require 'lambda/purchases/get'
require 'lambda/purchases/post'
require 'lambda/stores/get'
require 'sinatra'
require 'sinatra_shim/auth/inventory/store/isbn/get'
require 'sinatra_shim/auth/my/stores/get'
require 'sinatra_shim/auth/my/pile/get'
require 'sinatra_shim/auth/pile/get'
require 'sinatra_shim/auth/pile/post'
require 'sinatra_shim/auth/pile/put'
require 'sinatra_shim/offers/get'
require 'sinatra_shim/purchases/get'
require 'sinatra_shim/purchases/post'
require 'sinatra_shim/stores/get'

helpers AuthPilePost
helpers AuthPileGet
helpers AuthPilePut
helpers AuthMyPile
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

get '/auth/my/pile' do
  event = {
    'requestContext' => {
      'authorizer' => {
        'claims' => {
          'cognito:username' => ENV['INDY_AUTH_USERNAME']
        }
      }
    }
  }
  auth_my_pile_get(event)
end

post '/auth/pile' do
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
  auth_pile_post(event)
end

get '/auth/pile/*' do
  event = {
    'pathParameters' => {
      'proxy' =>  params[:splat][0]
    },
    'requestContext' => {
      'authorizer' => {
        'claims' => {
          'cognito:username' => ENV['INDY_AUTH_USERNAME']
        }
      }
    }
  }
  auth_pile_get(event)
end

put '/auth/pile/*' do
  event = {
    'pathParameters' => {
      'proxy' =>  params[:splat][0]
    },
    'requestContext' => {
      'authorizer' => {
        'claims' => {
          'cognito:username' => ENV['INDY_AUTH_USERNAME']
        }
      }
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
