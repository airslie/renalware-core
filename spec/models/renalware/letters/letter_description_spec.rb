# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Letters
    describe Description, type: :model do
      it_behaves_like "a Paranoid model"
      it { is_expected.to validate_presence_of :text }
    end
  end
end
