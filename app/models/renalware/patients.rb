require_dependency "renalware/pathology"
require_dependency "renalware/feeds"
require "subscription_registry"

module Renalware
  module Patients
    module_function

    def table_name_prefix
      "patient_"
    end

    def configure
      # Note that we no longer create all patients that coe in from the HL7 feed, so
      # MessageListener has been removed from the registry.
      # SubscriptionRegistry.instance.register(Feeds::MessageProcessor, MessageListener)
    end

    def self.cast_user(user)
      ActiveType.cast(user, ::Renalware::Patients::User)
    end
  end
end
