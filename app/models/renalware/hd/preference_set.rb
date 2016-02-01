require_dependency "renalware/hd"

module Renalware
  module Hd
    class PreferenceSet < ActiveRecord::Base
      include PatientScope

      belongs_to :patient, class_name: "Renalware::Patient"
      # belongs_to :hospital_unit

      # has_paper_trail class_name: "Renalware::Transplants::Version"
    end
  end
end
