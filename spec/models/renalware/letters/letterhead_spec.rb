# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Letters
    RSpec.describe Letterhead, type: :model do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:unit_info) }
      it { is_expected.to validate_presence_of(:trust_name) }
      it { is_expected.to validate_presence_of(:trust_caption) }
      it { is_expected.to respond_to(:include_pathology_in_letter_body?) }
    end
  end
end
