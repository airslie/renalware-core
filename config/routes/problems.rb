# frozen_string_literal: true

resources :patients, only: [] do
  resource :comorbidities, controller: "problems/comorbidities"
  resources :problems, controller: "problems/problems" do
    post :sort, on: :collection
    resources :notes, controller: "problems/notes"
  end
end
