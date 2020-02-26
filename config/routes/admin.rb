# frozen_string_literal: true

namespace :admin do
  resources :users
  resource :dashboard, only: :show
  namespace :feeds do
    resources :files, only: [:index, :show, :new, :create]
  end
  resource :cache, only: [:show, :destroy]
end
