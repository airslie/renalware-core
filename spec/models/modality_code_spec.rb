require 'rails_helper'

RSpec.describe ModalityCode, :type => :model do
  it { should have_many :patient_modalities }
  it { should have_many(:patients).through(:patient_modalities)}
end
