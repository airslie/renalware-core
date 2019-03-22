# frozen_string_literal: true

resources :patients, only: [] do
  resources :events, only: [:new, :create, :index], controller: "events/events"
  constraints(format: /(pdf)/) do
    resources :events, only: :show, controller: "events/events"
  end

  resources :swabs,
            only: [:new, :create, :edit, :update],
            controller: "events/swabs",
            defaults: { slug: :swabs }

  resources :investigations,
            only: [:new, :create, :edit, :update],
            controller: "events/investigations",
            defaults: { slug: :investigations }

  # Here we could enable new event by any other slug
  # eg patient_new_specific_event(slug: "transplant_biopsies")
  # get "events/:slug/new",
  #     to: "events/events#new",
  #     as: :new_specific_event
  # or we could hardwire routes as we do for swabs.
end

namespace :events do
  resources :types, except: :show
end
