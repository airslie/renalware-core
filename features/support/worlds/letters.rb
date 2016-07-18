module World
  module Letters
    def letters_patient(patient)
     Renalware::Letters.cast_patient(patient)
    end
  end
end

Dir[Rails.root.join("features/support/worlds/letters/*.rb")].each { |f| require f }
