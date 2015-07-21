require 'rails_helper'

describe ClinicLetter, type: :model do
  subject { create(:clinic_letter) }

  it { should validate_presence_of :clinic_id }
end
