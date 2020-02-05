# frozen_string_literal: true

module World
  module Clinical
    def clinical_patient(patient)
      Renalware::Clinical.cast_patient(patient)
    end
  end
end

Dir[Renalware::Engine.root.join("features/support/worlds/clinical/*.rb")]
  .sort.each { |f| require f }
