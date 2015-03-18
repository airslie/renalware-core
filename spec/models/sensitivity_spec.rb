require 'rails_helper'

RSpec.describe Sensitivity, :type => :model do
  it { should have_many(:infection_organisms) }
end
