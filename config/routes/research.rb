# frozen_string_literal: true

namespace :research do
  resources :studies do
    resources :participants, controller: :study_participants
  end
end
