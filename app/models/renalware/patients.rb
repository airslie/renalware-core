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
      SubscriptionRegistry.instance.register(Feeds::MessageProcessor, MessageListener)
    end
  end
end
