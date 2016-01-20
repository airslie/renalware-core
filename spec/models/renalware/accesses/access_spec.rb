require "rails_helper"

module Renalware
  module Accesses
    describe Access do
      it { is_expected.to validate_presence_of(:source_type) }
      it { is_expected.to validate_presence_of(:source_id) }
      it { is_expected.to validate_presence_of(:description_id) }
      it { is_expected.to validate_presence_of(:site_id) }
      it { is_expected.to validate_presence_of(:side) }

      describe "#valid?" do
        let(:attributes) { { source: create(:patient) } }

        subject { Access.new(attributes_for(:access).merge(attributes)) }

        it { is_expected.to be_valid }
      end
    end
  end
end