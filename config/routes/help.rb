namespace :help do
  namespace :tours, constraints: { format: :json }, defaults: { format: :json } do
    resources :pages, only: :show
  end
end
