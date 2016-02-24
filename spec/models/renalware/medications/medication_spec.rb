require 'rails_helper'
require './spec/support/login_macros'

module Renalware
  RSpec.describe Medication, :type => :model do
    it { should validate_presence_of :patient }
    it { should validate_presence_of :treatable }
    it { should validate_presence_of(:drug) }
    it { should validate_presence_of(:dose) }
    it { should validate_presence_of(:medication_route) }
    it { should validate_presence_of(:frequency) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:provider) }

    describe "#valid?" do
      context "route description" do
        context "given a route" do
          before { subject.medication_route = build(:medication_route) }

          it { is_expected.not_to validate_presence_of(:route_description) }
        end

        context "given a `other` route" do
          before { subject.medication_route = build(:medication_route, :other) }

          it { is_expected.to validate_presence_of(:route_description) }
        end

        context "given a route and a route description" do
          before do
            subject.medication_route = build(:medication_route)
            subject.route_description = "::route description::"
          end

          it "adds an error" do
            subject.valid?

            expect(subject.errors[:route_description]).to be_present
          end
        end
      end
    end
  end
end
