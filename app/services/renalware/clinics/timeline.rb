# frozen_string_literal: true

module Renalware
  class Clinics::Timeline < Patients::TimelineItem
    def type = "Clinic Visit"

    def fetch
      Clinics::ClinicVisit.joins(:clinic)
    end

    def description
      record.clinic.name
    end
  end
end
