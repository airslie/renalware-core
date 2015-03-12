require 'rails_helper'

RSpec.describe Medication, :type => :model do
  it { should belong_to(:patient) }
  it { should belong_to(:medicate_with) }
end
