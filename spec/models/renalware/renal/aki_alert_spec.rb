# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe Renal::AKIAlert, type: :model do
    it_behaves_like "an Accountable model"
    it { is_expected.to validate_presence_of(:patient) }
    it { is_expected.to have_db_index(:hotlist) }
    it { is_expected.to have_db_index(:action) }
    it { is_expected.to belong_to(:action).class_name("AKIAlertAction") }
    it { is_expected.to belong_to(:hospital_ward) }
    it { is_expected.to belong_to(:patient).touch(true) }
  end
end
