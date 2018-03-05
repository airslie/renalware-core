# frozen_string_literal: true

require "rails_helper"

module Renalware
  module PD
    describe Assessment, type: :model do
      it_behaves_like "an Accountable model"
      it { is_expected.to respond_to(:document) }
      it { is_expected.to respond_to(:by) } # i.e. Accountable has been included
      it { is_expected.to belong_to(:patient).touch(true) }

      describe "Document" do
        subject { Assessment::Document.new }

        it { is_expected.to respond_to(:had_home_visit) }
        # no need to test presence of other attributes
      end
    end
  end
end
