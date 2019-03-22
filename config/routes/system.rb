# frozen_string_literal: true

namespace :system do
  resources :email_templates, only: :index
  resources :user_feedback, except: :destroy, controller: "user_feedback"
  resources :messages
end

match "/404", to: "system/errors#not_found", via: :all
match "/500", to: "system/errors#internal_server_error", via: :all
match "/generate_test_internal_server_error",
      to: "system/errors#generate_test_internal_server_error",
      via: :get
resources :mock_errors, only: [:index], controller: "system/mock_errors"

devise_for :users,
           class_name: "Renalware::User",
           controllers: {
             registrations: "renalware/devise/registrations",
             sessions: "renalware/devise/sessions",
             passwords: "renalware/devise/passwords"
           },
           module: :devise

# An ajax-polled route which will cause the users browser to redirect to the login page
#  when their session expires
get "/session_timed_out" => "session_timeout#has_user_timed_out", as: "session_timed_out"

super_admin_constraint = lambda do |request|
  current_user = request.env["warden"].user || Renalware::NullUser.new
  current_user.has_role?(:super_admin)
end

constraints super_admin_constraint do
  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]
end

# enable mail previews in all environments
get "/rails/mailers" => "rails/mailers#index"
get "/rails/mailers/*path" => "rails/mailers#preview"
