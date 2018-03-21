# frozen_string_literal: true

require_dependency "renalware/problems"

module Renalware
  module Patients
    class Version < PaperTrail::Version
      self.table_name = :patient_versions
    end
  end
end
