# frozen_string_literal: true

resources :patients, only: [] do
  namespace :letters do
    resources :contacts, only: [:index, :new, :create, :edit, :update]
    resources :letters do
      resource :pending_review, controller: "pending_review_letters", only: :create
      resource :rejected, controller: "rejected_letters", only: :create
      resource :approved, controller: "approved_letters", only: :create
      resource :completed, controller: "completed_letters", only: [:new, :create]
      resource :formatted, controller: "formatted_letters", only: :show
      resource :printable,
               controller: "printable_letters",
               only: :show,
               constraints: { format: /(pdf)/ },
               defaults: { format: :pdf }
      collection do
        get :contact_added
      end
    end
  end
end

namespace :letters do
  resources :descriptions do
    post :sort, on: :collection
  end
  resources :mailshots, only: [:create, :new, :index], controller: "mailshots/mailshots"
  namespace :mailshots do
    resources :patient_previews, only: :index
  end

  resources :batches, only: [:create, :index, :show] do
    get :status, constraints: { format: :json }, defaults: { format: :json }
    resources :completions, only: [:new, :create], controller: "completed_batches"
  end
  resource :pdf_letter_cache, only: [:destroy], controller: "pdf_letter_cache"

  # Letters::ListsController displays prefined lists of letters. The default list is :all
  # We want to support dynamic urls with letters_list_path(named_parameeter: :all)
  # as well as named routes eg letters_list_all_path.
  # If you use the helper list_batch_printable_path, the named route is used to build the url,
  # but when it is accessed it is actually the first, dynamic route definition that matches first,
  # so the named_filter paramters is populated when we hit the controller.
  constraints(named_filter: /(all|batch_printable)/) do
    get "list/:named_filter", to: "lists#show", as: :filtered_letters_list
  end
  get "list/batch_printable", to: "lists#show", as: :list_batch_printable
  get "list/all", to: "lists#show", as: :list_all
  get "list", to: "lists#show", as: :list, defaults: { named_filter: :all }

  resources :letters, only: [] do
    resources :electronic_receipts, only: [] do
      patch :mark_as_read, on: :member
    end
  end
  resources :electronic_receipts, only: [] do
    collection do
      get :unread
      get :read
      get :sent
    end
  end
end
get "authors/:author_id/letters", to: "letters/letters#author", as: "author_letters"
