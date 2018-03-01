# frozen_string_literal: true

Rails.application.routes.draw do
  mount Renalware::Engine => "/"
  resources :dummies, only: :index
end
