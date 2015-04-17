require 'rails_helper'

RSpec.describe ModalityCode, :type => :model do
  it { should have_many :modalities }
  it { should have_many(:patients).through(:modalities)}
end
