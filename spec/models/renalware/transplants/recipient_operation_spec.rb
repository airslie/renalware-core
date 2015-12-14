require "rails_helper"
require "age_calculator"
require "renalware/automatic_age_calculator"

module Renalware
  module Transplants
    describe RecipientOperation do
      it { is_expected.to validate_presence_of(:performed_on) }
      it { is_expected.to validate_presence_of(:theatre_case_start_time) }
      it { is_expected.to validate_presence_of(:donor_kidney_removed_from_ice_at) }
      it { is_expected.to validate_presence_of(:kidney_perfused_with_blood_at) }
      it { is_expected.to validate_presence_of(:operation_type) }
      it { is_expected.to validate_presence_of(:transplant_site) }
      it { is_expected.to validate_presence_of(:cold_ischaemic_time) }

      it { is_expected.to validate_timeliness_of(:donor_kidney_removed_from_ice_at) }
      it { is_expected.to validate_timeliness_of(:donor_kidney_removed_from_ice_at) }
      it { is_expected.to validate_timeliness_of(:kidney_perfused_with_blood_at) }
      it { is_expected.to validate_timeliness_of(:theatre_case_start_time) }
      it { is_expected.to validate_timeliness_of(:cold_ischaemic_time) }

      subject { build(:transplant_recipient_operation) }

      describe "#before_validation" do
        let(:calculator) { double.as_null_object }
        let(:age) { Age.new }

        it "computes the age of the donor" do
          expect(Renalware::AutomaticAgeCalculator).to receive(:new).and_return(calculator)
          expect(calculator).to receive(:compute).and_return(age)

          subject.valid?

          expect(subject.document.donor.age).to eq(age)
        end
      end
    end
  end
end
