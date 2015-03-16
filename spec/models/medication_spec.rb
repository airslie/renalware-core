require 'rails_helper'

RSpec.describe Medication, :type => :model do
  it { should belong_to(:patient) }
  it { should belong_to(:medicatable) }
  it { should belong_to(:treatable) }
  it { should belong_to(:medication_route) }
end
