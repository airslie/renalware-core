require 'rails_helper'

RSpec.describe Medication, :type => :model do
  it { should belong_to(:patient) }
  it { should belong_to(:medicatable) }
  it { should belong_to(:treatable) }
  it { should belong_to(:medication_route) }

  it { should validate_presence_of :medicatable }
  it { should validate_presence_of :dose }
  it { should validate_presence_of :medication_route_id }
  it { should validate_presence_of :frequency }
  it { should validate_presence_of :start_date }
end
