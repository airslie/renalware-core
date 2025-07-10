# frozen_string_literal: true

module Renalware
  class Clinics::TimelineItem < TimelineItem
    private

    def scope
      Clinics::ClinicVisit.joins(:clinic)
    end
  end
end
