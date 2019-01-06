# frozen_string_literal: true

require "rails_helper"

module Renalware
  module HD
    describe Profile, type: :model do
      it_behaves_like "an Accountable model"
      it_behaves_like "a Supersedable model"
      it { is_expected.to validate_presence_of(:patient) }
      it { is_expected.to validate_presence_of(:prescriber) }
      it { is_expected.to respond_to(:active) }
      it { is_expected.to belong_to(:patient).touch(true) }
      it { is_expected.to belong_to(:dialysate) }
      it { is_expected.to belong_to(:schedule_definition) }
    end
  end
end
