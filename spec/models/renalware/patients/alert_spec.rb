require "rails_helper"

module Renalware
  module Patients
    describe Alert do
      it_behaves_like "a Paranoid model"
      it_behaves_like "an Accountable model"
      it { is_expected.to validate_presence_of(:notes) }
      it { is_expected.to validate_presence_of(:patient) }
      it { is_expected.to belong_to(:patient).touch(true) }
    end
  end
end
