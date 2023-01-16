# frozen_string_literal: true

namespace :deaths do
  resources :locations, except: :show
end
