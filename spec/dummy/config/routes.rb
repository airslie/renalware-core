# frozen_string_literal: true

Rails.application.routes.draw do
  mount Renalware::Engine => "/", as: :renalware
  resources :dummies, only: :index
end
