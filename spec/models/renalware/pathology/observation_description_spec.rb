# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe Pathology::ObservationDescription, type: :model do
    it { is_expected.to belong_to(:measurement_unit) }
    it { is_expected.to have_db_index(:code).unique(true) }
    it { is_expected.to have_many(:code_group_memberships) }
    it { is_expected.to have_many(:code_groups).through(:code_group_memberships) }
  end
end
