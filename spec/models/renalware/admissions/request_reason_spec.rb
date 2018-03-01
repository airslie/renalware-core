# frozen_string_literal: true

require "rails_helper"

RSpec.describe Renalware::Admissions::RequestReason, type: :model do
  it { is_expected.to validate_presence_of :description }
  it_behaves_like "a Paranoid model"
end
