# Example pathology listener.
#
# This listener had been wired to receive the letter_approved broadcast events in the
# broadcast_subscription_map. See config/initializers/renalware.rb
#
module Renalware
  module Pathology
    class Listener
      # The observation_request is about to saved.
      def before_observation_request_persisted(obr_attributes)
        # ...
      end

      # The observation_request has just been saved.
      def after_observation_request_persisted(observation_request)
        # ...
      end
    end
  end
end
