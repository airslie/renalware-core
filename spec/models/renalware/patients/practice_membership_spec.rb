# frozen_string_literal: true

require "rails_helper"

module Renalware::Patients
  describe PracticeMembership, type: :model do
    it { is_expected.to belong_to(:practice) }
    it { is_expected.to belong_to(:primary_care_physician) }
    it_behaves_like "a Paranoid model"
  end
end
