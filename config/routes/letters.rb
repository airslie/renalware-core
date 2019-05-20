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
  resource :pdf_letter_cache, only: [:destroy], controller: "pdf_letter_cache"
  resources :descriptions, only: :search do
    collection do
      get :search
    end
  end
  resource :list, only: :show
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
