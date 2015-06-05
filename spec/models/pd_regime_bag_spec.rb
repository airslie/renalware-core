require 'rails_helper'

RSpec.describe PdRegimeBag, :type => :model do

  it { should belong_to :bag_type }
  it { should belong_to :pd_regime }

end
