require "rails_helper"

module Renalware
  module Accesses
    describe Access do
      it { is_expected.to validate_presence_of(:source) }
      it { is_expected.to validate_presence_of(:description) }
      it { is_expected.to validate_presence_of(:site) }
      it { is_expected.to validate_presence_of(:side) }
    end
  end
end