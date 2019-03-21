# frozen_string_literal: true

namespace :directory do
  resources :people, except: [:delete] do
    collection do
      get :search
    end
  end
end
