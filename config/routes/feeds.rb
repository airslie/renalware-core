# frozen_string_literal: true

namespace :feeds do
  resources :hl7_test_messages
  resources :outgoing_documents, constraints: { format: :json }, defaults: { format: :json }
end
