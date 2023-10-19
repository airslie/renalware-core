# frozen_string_literal: true

resources :patients, only: [] do
  resources :modalities, controller: "modalities/modalities"
end

namespace :modalities do
  resources :descriptions, except: [:show]
  resources :reasons, only: [:index]
end
