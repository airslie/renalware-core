# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe Pathology::CodeGroupMembership, type: :model do
    it { is_expected.to validate_presence_of(:subgroup) }
    it { is_expected.to validate_presence_of(:position_within_subgroup) }
    it { is_expected.to belong_to(:code_group) }
    it { is_expected.to belong_to(:observation_description) }
  end
end
