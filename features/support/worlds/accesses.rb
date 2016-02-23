module World
  module Accesses
    def accesses_patient(patient)
      ActiveType.cast(patient, Renalware::Accesses::Patient)
    end
  end
end

Dir[Rails.root.join("features/support/worlds/accesses/*.rb")].each { |f| require f }
