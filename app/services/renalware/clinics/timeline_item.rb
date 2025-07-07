# frozen_string_literal: true

module Renalware
  # NOTE: Do we need to display Dietetic Clinic Visit?
  class Clinics::TimelineItem < Patients::TimelineItem
    def type = "Clinic Visit"

    def description
      record.clinic.name
    end

    def detail
      ""
    end

    private

    def fetch
      Clinics::ClinicVisit.joins(:clinic)
    end
  end
end
