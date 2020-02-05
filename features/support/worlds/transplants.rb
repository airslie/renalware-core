# frozen_string_literal: true

module World
  module Transplants
    def transplant_patient(patient)
      Renalware::Transplants.cast_patient(patient)
    end
  end
end

Dir[Renalware::Engine.root.join("features/support/worlds/transplants/*.rb")]
  .sort.each { |f| require f }
