require 'rails_helper'

RSpec.describe FluidDescription, :type => :model do
   it { should have_many(:peritonitis_episodes) }
end
