require 'rails_helper'

RSpec.describe ModalityCode, :type => :model do
  it { should have_many :patient_modality }
  it { should have_many(:patients).through(:patient_modality)}
end
