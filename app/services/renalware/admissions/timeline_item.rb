# frozen_string_literal: true

module Renalware
  class Admissions::TimelineItem < TimelineItem
    private

    def scope
      Admissions::Admission.joins(:hospital_ward)
    end
  end
end
