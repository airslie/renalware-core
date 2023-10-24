# frozen_string_literal: true

resources :patients, only: [] do
  namespace :transplants do
    resource :mdm, only: :show, controller: "mdm"

    scope "/donor" do
      resource :donor_dashboard, only: :show, path: "/dashboard"
      resource :donor_workup, only: [:show, :edit, :update], path: "/workup"
      resources :donor_operations, except: [:index, :destroy], path: "/operations" do
        resource :followup,
                 except: :destroy,
                 controller: "donor_followups",
                 path: "/follow_up"
      end
      resources :donations, except: [:index, :destroy]
      resource :donor_stage, only: [:new, :create], path: "/stage"
    end

    scope "/recipient" do
      resource :recipient_dashboard, only: :show, path: "/dashboard"
      resource :recipient_workup, only: [:show, :edit, :update], path: "/workup"
      resources :recipient_operations, except: [:index, :destroy], path: "/operations" do
        resource :followup,
                 except: :destroy,
                 controller: "recipient_followups",
                 path: "/follow_up"
      end
      resource :registration, only: [:show, :edit, :update] do
        resources :statuses, except: [:index, :show], controller: "registration_statuses"
      end
    end
  end
end

namespace :transplants do
  constraints(named_filter: /#{Renalware::Transplants::WAITLIST_FILTERS.join("|")}/) do
    get "wait_list/:named_filter", to: "wait_lists#show", as: :wait_list
  end
  resources :live_donors, only: :index
  resources :mdm_patients, only: :index
  constraints(named_filter: /(recent|on_worryboard|past_year)/) do
    get "mdm_patients/:named_filter", to: "mdm_patients#index", as: :filtered_mdm_patients
  end
end
