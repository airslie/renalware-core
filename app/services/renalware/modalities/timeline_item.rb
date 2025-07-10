# frozen_string_literal: true

module Renalware
  class Modalities::TimelineItem < TimelineItem
    private

    def scope
      Modalities::Modality.joins(:description)
    end
  end
end
