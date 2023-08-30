Rails.application.routes.draw do
  devise_for :users, :controllers => {
    registrations: 'registrations'
  }

  resources :services, shallow: true do
    resources :slots
    resources :events
    resources :slot_rules
  end

  resource :time_zone

  get '/:id', to: 'services#show'

  root 'services#index'
end
