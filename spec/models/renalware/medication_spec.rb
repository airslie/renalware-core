require 'rails_helper'
require './spec/support/login_macros'

module Renalware
  RSpec.describe Medication, :type => :model do
    it { should validate_presence_of :patient }
    it { should validate_presence_of(:drug) }
    it { should validate_presence_of(:dose) }
    it { should validate_presence_of(:medication_route_id) }
    it { should validate_presence_of(:frequency) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:provider) }
  end
end
