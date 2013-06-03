TrophicWeb::Application.routes.draw do

  root :to => "page#home"

  resources :registrations
  get '/registration',            :to => 'registrations#new'

  get '/location',                :to => 'page#location'
  get '/location_count',          :to => 'page#location_count'
  get '/locations',               :to => 'page#locations'
  get '/food_chain',              :to => 'interaction#food_chain'
  post '/food_chain',             :to => 'interaction#food_chain'
  get '/thumbnails',              :to => 'images#thumbnails'

  get '/about',                   :to => 'page#about'
  get '/code_of_ethics',          :to => 'page#code_of_ethics'
  get '/funding_sources',         :to => 'page#funding_sources'
  get '/partners',                :to => 'page#partners'
  get '/data_contributors',       :to => 'page#data_contributors'

  get '/search',                  :to => 'page#search'

end
