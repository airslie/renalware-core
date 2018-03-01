# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Accesses
    describe CatheterInsertionTechnique do
      it { is_expected.to validate_presence_of(:code) }
      it { is_expected.to validate_presence_of(:description) }
    end
  end
end
