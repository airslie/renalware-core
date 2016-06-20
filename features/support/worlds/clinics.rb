module World
  module Clinics
    def clinics_patient(patient)
      ActiveType.cast(patient, Renalware::Clinics::Patient)
    end
  end
end

Dir[Rails.root.join("features/support/worlds/clinics/*.rb")].each { |f| require f }
