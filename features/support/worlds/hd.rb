module World
  module HD
    def hd_patient(patient)
      Renalware::HD.cast_patient(patient)
    end
  end
end

Dir[Rails.root.join("features/support/worlds/hd/*.rb")].each { |f| require f }
