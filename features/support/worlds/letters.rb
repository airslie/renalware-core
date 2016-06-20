module World
  module Letters
    def letters_patient(patient)
      ActiveType.cast(patient, Renalware::Letters::Patient)
    end

    def letters_clinic_visit(clinic_visit)
      ActiveType.cast(clinic_visit, Renalware::Letters::ClinicVisit)
    end
  end
end

Dir[Rails.root.join("features/support/worlds/letters/*.rb")].each { |f| require f }
