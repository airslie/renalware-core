# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Letters
    describe BatchItem, type: :model do
      it { is_expected.to belong_to :letter }
      it { is_expected.to belong_to :batch }
    end
  end
end
