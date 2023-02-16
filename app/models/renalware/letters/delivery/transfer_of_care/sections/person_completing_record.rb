# frozen_string_literal: true

module Renalware
  module Letters::Delivery::TransferOfCare
    class Sections::PersonCompletingRecord < Sections::Base
      def snomed_code = "887231000000104"
      def title = "Person completing record"
      def entries = [{ reference: arguments.author_urn }]
    end
  end
end
