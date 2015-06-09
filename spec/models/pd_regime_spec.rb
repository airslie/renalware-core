require 'rails_helper'

RSpec.describe PdRegime, :type => :model do

  it { should belong_to :patient }

  it { should have_many :pd_regime_bag }
  it { should have_many(:bag_types).through(:pd_regime_bag) }

end
