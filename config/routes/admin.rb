namespace :admin do
  resources :users
  resources :heidi_sessions, only: :index
  resources :safety_alert_rules, only: :index do
    member do
      patch :enable
      patch :disable
      post :run
    end
  end
  resources :safety_alert_rule_executions, only: :index
  resource :dashboard, only: :show
  resource :playground, only: :show do
    scope constraints: { format: :json } do
      get :pathology_chart_data
    end
  end
  namespace :feeds do
    resources :files, only: %i(index show new create)
  end
  resource :cache, only: %i(show destroy)
  resource :config, only: %i(show destroy), controller: "config"
end
