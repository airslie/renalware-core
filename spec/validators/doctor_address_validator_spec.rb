require 'rails_helper'

describe DoctorAddressValidator do
  describe 'validate' do
    it 'validates an address is present on the Doctor' do
      doc = build_stubbed(:doctor, address: nil)
      DoctorAddressValidator.new.validate(doc)
      expect(doc.errors[:address]).to match_array(['Must have an address or a practice with an address.'])
    end

    it 'does nothing when the doctor has an address' do
      doc = build_stubbed(:doctor, practices: [build_stubbed(:practice)])
      DoctorAddressValidator.new.validate(doc)
      expect(doc.errors[:address]).to be_empty
    end
  end
end
