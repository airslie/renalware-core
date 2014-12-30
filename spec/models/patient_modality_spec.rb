require 'rails_helper'

RSpec.describe PatientModality, :type => :model do
  it { should belong_to(:modality_code) }
  it { should belong_to(:patient) }
  it { should belong_to(:modality_reason) }
end
