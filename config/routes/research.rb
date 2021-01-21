# frozen_string_literal: true

namespace :research do
  resources :studies do
    resources :participations, controller: :participations
    resources :memberships, controller: :memberships
  end
end
