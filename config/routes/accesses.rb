# frozen_string_literal: true

resources :patients, only: [] do
  namespace :accesses do
    resource :dashboard, only: :show
    resources :assessments, except: [:index, :destroy]
    resources :procedures, except: [:index, :destroy]
    resources :profiles, except: [:index, :destroy]
    resources :plans, except: [:index, :destroy]
  end
end
