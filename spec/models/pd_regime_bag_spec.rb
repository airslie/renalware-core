require 'rails_helper'

RSpec.describe PdRegimeBag, :type => :model do

  it { should belong_to :bag_type }
  it { should belong_to :pd_regime }

  it { should validate_numericality_of(:volume).is_greater_than_or_equal_to(100).is_less_than_or_equal_to(10000) }

end
