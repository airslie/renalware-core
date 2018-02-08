require_dependency "renalware/virology"
require_dependency "renalware/events"
require "document/base"
require "document/embedded"
require "document/enum"

module Renalware
  module Virology
    class Vaccination < Events::Event
      include Document::Base

      # Return e.g. "renalware/virology/vaccinations/toggled_cell
      def partial_for(partial_type)
        File.join("renalware/virology/vaccinations", partial_type)
      end

      class Document < Document::Embedded
        attribute :type, ::Document::Enum # See i18n for options
        validates :type, presence: true
      end
      has_document
    end
  end
end
