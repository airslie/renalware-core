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
        it { is_expected.to validate_timeliness_of(:assessed_on) }
        it { is_expected.to validate_timeliness_of(:home_visit_on) }
        it { is_expected.to validate_timeliness_of(:access_clinic_on) }
      end
    end
  end
end
