require "rails_helper"

module Renalware
  RSpec.describe Medications::PrescriptionTermination, type: :model do
    it { is_expected.to validate_presence_of :terminated_on }
  end
end
