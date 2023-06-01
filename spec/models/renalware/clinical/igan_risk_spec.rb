# frozen_string_literal: true

require "rails_helper"

describe Renalware::Clinical::IganRisk do
  it { is_expected.to have_db_index(:patient_id) }
  it { is_expected.to belong_to(:patient) }
  it { is_expected.to validate_presence_of(:patient) }
  it { is_expected.to validate_presence_of(:risk) }

  it {
    is_expected.to validate_numericality_of(:risk)
      .is_in(0.00..100.00)
      .allow_nil
  }
end
