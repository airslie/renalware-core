# frozen_string_literal: true

Renalware::Snippeting::Engine.routes.draw do
  resources :snippets, except: :show do
    resources :snippet_clones, only: :create, as: :clones
    resources :snippet_invocations, only: :create, as: :invocations
  end
end
