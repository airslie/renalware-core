require_dependency "renalware"
require_dependency "renalware/feeds"

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
      Feeds.subscribe_to_message_processor(MessageListener)
    end
  end
end
