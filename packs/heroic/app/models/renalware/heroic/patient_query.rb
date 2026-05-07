# frozen_string_literal: true

require "attr_extras"

module Renalware
  module Heroic
    class PatientQuery
      pattr_initialize :term

      def call
        find_patient_using_hospital_number
      end

      private

      # Find the first patient matching the identifier in an local_patient column
      def find_patient_using_hospital_number
        Patient
          .where(<<-SQL.squish, term, term, term, term, term).first
          local_patient_id = ? OR
          local_patient_id_2 = ? OR
          local_patient_id_3 = ? OR
          local_patient_id_4 = ? OR
          local_patient_id_5 = ?
          SQL
      end
    end
  end
end
