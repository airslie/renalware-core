require 'rails_helper'

describe DoctorEmailValidator do
  describe 'validate' do
    it 'validates an email is present on the Doctor' do
      doc = build_stubbed(:doctor, email: nil)
      DoctorEmailValidator.new.validate(doc)
      expect(doc.errors[:email]).to match_array(['Must have an email address or an contact email address at a practice.'])
    end

    it 'does nothing when the doctor has an email' do
      doc = build_stubbed(:doctor, practices: [build_stubbed(:practice)])
      DoctorEmailValidator.new.validate(doc)
      expect(doc.errors[:email]).to be_empty
    end
  end
end
