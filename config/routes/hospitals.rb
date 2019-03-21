# frozen_string_literal: true

namespace :hospitals do
  resources :units, except: :show do
    resources :wards
    scope format: true, constraints: { format: :json } do
      resources :wards, only: :index
    end
  end
end
