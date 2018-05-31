# frozen_string_literal: true

require "rails_helper"

describe Renalware::Pathology::RequestDescription do
  it { is_expected.to validate_presence_of(:lab) }
  it { is_expected.to have_db_index(:code).unique(true) }

  subject(:request_description) { build(:pathology_request_description) }

  describe "#to_s" do
    it { expect(request_description.to_s).to eq(request_description.code) }
  end
end
