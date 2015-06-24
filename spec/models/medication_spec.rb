require 'rails_helper'

RSpec.describe Medication, :type => :model do
  it { should belong_to(:patient) }
  it { should belong_to(:medicatable) }
  it { should belong_to(:treatable) }
  it { should belong_to(:medication_route) }

  it { should validate_presence_of :patient }

  it { should validate_presence_of(:medicatable).with_message("Medication to be administered can't be blank") }
  it { should validate_presence_of(:dose).with_message("Dose can't be blank") }
  it { should validate_presence_of(:medication_route_id).with_message("Route can't be blank") }
  it { should validate_presence_of(:frequency).with_message("Frequency & Duration can't be blank") }
  it { should validate_presence_of(:start_date).with_message("Prescribed On can't be blank") }
end
