module World
  module Letters
    def letters_patient(patient)
     Renalware::Letters.cast_patient(patient)
    end

    def create_contact(patient:, user:)
      address = FactoryGirl.build(:address)
      person = FactoryGirl.build(:directory_person, address: address, by: user)
      FactoryGirl.create(:letter_contact, patient: patient, person: person)
    end
  end
end

Dir[Rails.root.join("features/support/worlds/letters/*.rb")].each { |f| require f }
