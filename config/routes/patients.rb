# frozen_string_literal: true

namespace :patients do
  get "mdms/:scope", to: "mdms#show", as: :mdms
  resources :primary_care_physicians
  resources :practices, only: [] do
    collection do
      get :search
    end
    resources :primary_care_physicians,
              only: :index,
              controller: "practices/primary_care_physicians"
  end
  resources :abridgements, only: :index
end

resources :bookmarks, controller: "patients/bookmarks", only: [:destroy, :index]
resource :dashboard, only: :show, controller: "dashboard/dashboards"
resource :worryboard, only: :show, controller: "patients/worryboard"
resources :deaths, only: :index, as: :patient_deaths

resources :patients, except: [:destroy], controller: "patients/patients" do
  collection do
    get :search
  end

  resource :clinical_summary, only: :show, controller: "patients/clinical_summaries"
  resource :death, only: [:edit, :update]
  resource :primary_care_physician,
           controller: "patients/primary_care_physician",
           only: [:edit, :update, :destroy]

  resources :bookmarks, only: :create, controller: "patients/bookmarks"
  resources :alerts, only: [:new, :create, :destroy], controller: "patients/alerts"
  resource :worry, only: [:create, :destroy], controller: "patients/worry"
  resources :attachments, controller: "patients/attachments"

  # Problems
  resources :problems, controller: "problems/problems" do
    post :sort, on: :collection
    resources :notes, controller: "problems/notes"
  end

  namespace :surveys do
    resource :dashboard, only: :show
  end
end
