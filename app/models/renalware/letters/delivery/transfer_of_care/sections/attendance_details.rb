# frozen_string_literal: true

module Renalware
  module Letters::Delivery::TransferOfCare
    class Sections::AttendanceDetails < Sections::Base
      def title = "Attendance details"
      def snomed_code = "1077881000000105"
    end
  end
end
