namespace :api do
  # The UKRDC XML API
  namespace :ukrdc, defaults: { format: :xml } do
    resources :patients,
              only: :show,
              constraints: { format: :xml }
  end

  # The JSON API
  namespace :v1, constraints: { format: :json }, defaults: { format: :json } do
    namespace :monitoring do
      namespace :mirth do
        resource :channel_stats, only: :create
      end
    end

    namespace :hd do
      # called by hd_hub on receipt of a session data fron a dialyser
      put(
        "sessions/:mrn/:date",
        to: "sessions#update",
        as: :session,
        constraints: {
          date: /\d\d\d\d-\d\d-\d\d/
        }
      )
    end
  end
end
