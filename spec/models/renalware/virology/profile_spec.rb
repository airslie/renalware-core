# frozen_string_literal: true

require "rails_helper"

RSpec.describe Renalware::Virology::Profile do
  it { is_expected.to belong_to(:patient).touch(true) }
  it { is_expected.to respond_to(:document) }
  it { is_expected.to have_db_index(:document) }
  it { is_expected.to have_db_index(:patient_id) }
end
