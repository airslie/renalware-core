# frozen_string_literal: true

resources :users, only: :index
resources :user_groups, controller: "users/groups"
