# frozen_string_literal: true

require_dependency "renalware"
require_dependency "renalware/feeds"
require "subscription_registry"

module Renalware
  module Pathology
    module_function

    def table_name_prefix
      "pathology_"
    end

    def cast_patient(patient)
      ActiveType.cast(patient, ::Renalware::Pathology::Patient)
    end

    def configure
      SubscriptionRegistry.instance.register(Feeds::MessageProcessor, MessageListener)
    end

    class MissingRequestDescriptionError < StandardError; end
    class MissingObservationDescriptionError < StandardError; end
  end
end
