# frozen_string_literal: true

namespace :drugs do
  resources :drugs, except: :show do
    collection do
      scope format: true, constraints: { format: :json } do
        get :selected_drugs
      end
    end
  end
end
