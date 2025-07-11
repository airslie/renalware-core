# frozen_string_literal: true

module Renalware
  class Admissions::TimelineItem < TimelineItem
    private

    def scope
      Admissions::Admission.eager_load(:hospital_ward)
    end
  end
end
