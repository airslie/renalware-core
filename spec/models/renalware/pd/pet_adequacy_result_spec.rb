require "rails_helper"

module Renalware
  module PD
    RSpec.describe PETAdequacyResult, type: :model do
      it { is_expected.to belong_to(:patient).touch(true) }

      describe "validation" do
        before do
          # Thus is a small performance optimisation to speed up shoulda's validation tests.
          # The tests are spending a lot of time looking up error messages.
          allow_any_instance_of(ActiveModel::Errors)
            .to receive(:generate_message)
            .and_return("error message")
        end
        PETAdequacyResult::MAXIMUMS.each do |attr_name, max_value|
          it do
            is_expected.to validate_numericality_of(attr_name).is_less_than_or_equal_to(max_value)
          end
        end
      end

      describe "pet_type" do
        it "is an enumerized enum" do
          expect(subject.class.pet_type.values).to be_kind_of(Array)
        end
      end
    end
  end
end
