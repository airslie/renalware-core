# frozen_string_literal: true

resources :patients, only: [] do
  resources :modalities, only: [:new, :create, :index], controller: "modalities/modalities"
end

namespace :modalities do
  resources :descriptions, except: [:show]
  resources :reasons, only: [:index]
end
