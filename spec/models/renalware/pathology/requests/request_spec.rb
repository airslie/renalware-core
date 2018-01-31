require "rails_helper"

module Renalware
  RSpec.describe Pathology::Requests::Request, type: :model do
    it_behaves_like "an Accountable model"
    it { is_expected.to belong_to(:patient).touch(true) }
    it { is_expected.to belong_to(:clinic) }
    it { is_expected.to belong_to(:consultant) }
    it { is_expected.to have_and_belong_to_many(:request_descriptions) }
    it { is_expected.to have_and_belong_to_many(:patient_rules) }

    it { is_expected.to validate_presence_of(:patient) }
    it { is_expected.to validate_presence_of(:clinic) }
    it { is_expected.to validate_presence_of(:consultant) }
    it { is_expected.to validate_presence_of(:template) }
  end
end
