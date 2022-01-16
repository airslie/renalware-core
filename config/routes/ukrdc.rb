# frozen_string_literal: true

namespace :ukrdc do
  resources :transmission_logs, only: :index
end
