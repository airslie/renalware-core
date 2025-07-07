# frozen_string_literal: true

module Renalware
  class Modalities::TimelineItem < Patients::TimelineItem
    def type = "Modality Change"

    def description
      record.description.name
    end

    private

    def fetch
      Modalities::Modality.joins(:description)
    end
  end
end
