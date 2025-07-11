# frozen_string_literal: true

module Renalware
  class Modalities::TimelineItem < TimelineItem
    private

    def scope
      Modalities::Modality.eager_load(:description)
    end
  end
end
