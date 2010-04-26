Sitemap::Routes.host = 'http://yoursite.com'
Sitemap::Routes.priority = 0.8    # default is 1.0

Sitemap::Routes.draw  do |map|
  map.resources :breeds

  map.resources :users

  map.resources :reports

  map.resources :companies

  map.resources :groomers

  map.resources :pets

  map.resources :pet_images

  map.resources :pet_owners

  map.resources :appointments

  map.resources :report_engines

  map.root    :controller => 'home'
end
