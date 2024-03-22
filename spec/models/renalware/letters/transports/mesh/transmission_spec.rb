# frozen_string_literal: true

require "rails_helper"

module Renalware::Letters::Transports::Mesh
  describe Transmission do
    it { is_expected.to validate_presence_of(:letter) }
    it { is_expected.to belong_to(:letter) }
    it { is_expected.to have_db_index(:letter_id) }
  end
end
