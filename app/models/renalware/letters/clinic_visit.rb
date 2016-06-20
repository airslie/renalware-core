require_dependency "renalware/letters"

module Renalware
  module Letters
    class ClinicVisit < ActiveType::Record[Renalware::Clinics::ClinicVisit]
      has_one :letter, as: :event
    end
  end
end
