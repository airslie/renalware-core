# frozen_string_literal: true

require "rails_helper"

module Renalware
  module HD
    describe PrescriptionAdministrationReason, type: :model do
      it { is_expected.to have_db_index(:name).unique(true) }
    end
  end
end
