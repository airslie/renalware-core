# frozen_string_literal: true

module Renalware
  module Letters::Delivery::TransferOfCare
    class Sections::GPPractice < Sections::Base
      def snomed_code = "886711000000101"
      def title = "GP practice"
      def entries = [{ reference: arguments.organisation_urn }]
    end
  end
end
