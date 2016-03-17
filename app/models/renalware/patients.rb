require_dependency "renalware/pathology"

module Renalware
  module Patients
    module_function

    def configure
      Feeds.subscribe_to_message_processor(MessageListener)
    end
  end
end
