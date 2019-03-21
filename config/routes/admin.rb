# frozen_string_literal: true

namespace :admin do
  resources :users
  namespace :feeds do
    resources :files, only: [:index, :show, :new, :create]
  end
  resource :cache, only: [:show, :destroy]
end
