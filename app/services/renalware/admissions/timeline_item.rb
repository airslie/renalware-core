# frozen_string_literal: true

module Renalware
  class Admissions::TimelineItem < Patients::TimelineItem
    def type = "Admission"

    def description
      record.admission_type
    end

    def detail
      record.hospital_ward.name
    end

    private

    def fetch
      Admissions::Admission.joins(:hospital_ward)
    end
  end
end
