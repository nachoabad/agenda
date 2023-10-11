Rails.application.routes.draw do

  devise_for :users, :controllers => {
    registrations: 'registrations'
  }

  resources :services, shallow: true do
    resources :slots
    resources :events
    resources :slot_rules
  end

  resources :event_rules
  resources :payments, only: %i[index edit update]
  resources :incomes, only: %i[index show]
  resource :time_zone

  resources :web_leads, only: %i[create]
  get '/thanks', to: 'pages#thanks'

  get '/:id', to: 'services#show'

  root 'pages#index'
end
