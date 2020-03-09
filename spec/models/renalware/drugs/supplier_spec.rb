# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Drugs
    describe Supplier, type: :model do
      it { is_expected.to validate_presence_of :name }
    end
  end
end
