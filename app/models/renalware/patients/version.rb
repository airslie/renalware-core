# frozen_string_literal: true

module Renalware
  module Patients
    class Version < PaperTrail::Version
      self.table_name = :patient_versions
    end
  end
end
