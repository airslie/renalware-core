require 'rails_helper'

RSpec.describe BagType, :type => :model do

  it { should have_many :pd_regime_bags }

  it { should validate_presence_of :description }
end
