require 'rails_helper'

RSpec.describe ModalityReason, :type => :model do
  it { should have_many :modalities } 
end
