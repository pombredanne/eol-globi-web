TrophicWeb::Application.routes.draw do
  
  root :to => "page#home"
  
  resources :registrations
  get '/registration',            :to => 'registrations#new'
  
  get '/location',                :to => 'page#location'
  get '/locations',               :to => 'page#locations'
  get '/thumbnails',              :to => 'page#thumbnails'
  
  get '/about',                   :to => 'page#about'
  get '/code_of_ethics',          :to => 'page#code_of_ethics'
  get '/funding_sources',         :to => 'page#funding_sources'
  get '/partners',                :to => 'page#partners'
  get '/data_contributors',       :to => 'page#data_contributors'

  get '/search',                  :to => 'page#search'

end
