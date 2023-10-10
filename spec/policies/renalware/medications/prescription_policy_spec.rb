# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Medications
    describe PrescriptionPolicy, type: :policy do
      include PolicySpecHelper

      subject { described_class }

      let(:prescription) { Prescription.new }

      %i(new? create? edit? update? destroy?).each do |permission|
        permissions permission do
          context "when user has prescriber role but no clinical/admin/superadmin/devops" do
            let(:user) { user_double_with_role(%i(prescriber)) }

            it { is_expected.not_to permit(user, prescription) }
          end

          context "when user has prescriber role but only the readonly role" do
            let(:user) { user_double_with_role(%i(prescriber read_only)) }

            it { is_expected.not_to permit(user, prescription) }
          end
        end

        permissions permission do
          context "when user has prescriber role" do
            let(:user) { user_double_with_role(%i(clinical prescriber)) }

            it { is_expected.to permit(user, prescription) }
          end

          context "when user does not have the prescriber role" do
            let(:user) { user_double_with_role(%i(clinical)) }

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
