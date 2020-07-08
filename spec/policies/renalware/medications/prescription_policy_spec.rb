# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Medications
    describe PrescriptionPolicy, type: :policy do
      subject { described_class }

      let(:prescription) { Prescription.new }

      %i(new? create? edit? update? destroy?).each do |permission|
        permissions permission do
          context "when user has prescriber flag" do
            let(:user) { instance_double(Renalware::User, prescriber?: true, has_role?: true) }

            it { is_expected.to permit(user, prescription) }
          end

          context "when user does not have the prescriber flag" do
            let(:user) { instance_double(Renalware::User, prescriber?: false, has_role?: true) }

            context "when Renalware.config is set to enforce the prescriber flag" do
              before do
                allow(Renalware.config)
                  .to receive(:enforce_user_prescriber_flag)
                  .and_return(true)
              end

              it { is_expected.not_to permit(user, prescription) }
            end

            context "when Renalware.config is not enforcing the prescriber flag" do
              before do
                allow(Renalware.config)
                  .to receive(:enforce_user_prescriber_flag)
                  .and_return(false)
              end

              it { is_expected.to permit(user, prescription) }
            end
          end
        end
      end
    end
  end
end
