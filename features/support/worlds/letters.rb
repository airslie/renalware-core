module World
  module Letters
    def letters_patient(patient)
      ActiveType.cast(patient, Renalware::Letters::Patient)
    end
  end
end

Dir[Rails.root.join("features/support/worlds/letters/*.rb")].each { |f| require f }
