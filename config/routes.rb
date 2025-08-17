Rails.application.routes.draw do
  get 'tasks/date_events_reminder_emails'
  get 'tasks/event_rules_future_events'

  get '/google_redirect', to: 'google#redirect', as: 'google_redirect'
  get '/google_callback', to: 'google#callback', as: 'google_callback'
  get '/google_calendars', to: 'google#calendars', as: 'google_calendars'

  devise_for :users, :controllers => {
    registrations: 'registrations'
  }

  resources :services, shallow: true do
    resources :slots
    resources :events
    resources :slot_rules
    resources :date_blockers, only: %i[new create]
    resource  :main_menu, only: %i[show]
    resources :reminders, only: %i[create]
  end

  resources :event_rules
  resources :event_settings, only: %i[update]
  resources :payments, only: %i[index edit update]
  resources :incomes, only: %i[index show]
  resource :time_zone

  resources :web_leads, only: %i[create]
  get '/thanks', to: 'pages#thanks'

  get '/:id', to: 'services#show'

  root 'pages#index'
end
