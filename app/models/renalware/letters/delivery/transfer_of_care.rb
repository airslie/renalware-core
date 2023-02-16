# frozen_string_literal: true

require "fhir_stu3_models"

module Renalware
  module Letters
    module Delivery
      module TransferOfCare
        def self.table_name_prefix = "letter_delivery_toc_"
        module Resources; end
        module Sections; end
        module Lists; end
        module Concerns; end
      end
    end
  end
end
