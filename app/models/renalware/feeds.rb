require_dependency "renalware"

module Renalware
  module Feeds
    module_function

    def table_name_prefix
      "feed_"
    end

    def message_processor
      Renalware::Feeds::MessageProcessor.new
    end
  end
end
