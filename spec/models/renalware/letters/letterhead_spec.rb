# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Letters
    describe Letterhead do
      it :aggregate_failures do
        is_expected.to validate_presence_of(:name)
        is_expected.to validate_presence_of(:unit_info)
        is_expected.to validate_presence_of(:trust_name)
        is_expected.to validate_presence_of(:trust_caption)
        is_expected.to respond_to(:include_pathology_in_letter_body?)
      end
    end
  end
end
