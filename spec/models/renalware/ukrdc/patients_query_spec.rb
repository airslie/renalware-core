# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe UKRDC::PatientsQuery do
    let(:patient) { build(:patient, by: user) }
    let(:user) { create(:user) }

    it { is_expected.to respond_to(:call) }

    describe ".call" do
      context "when the optional :changed_since argument is not specified" do
        subject { described_class.new.call }

        context "when there no patients with send_to_rpv set" do
          it { is_expected.to be_empty }
        end

        context "when a patient has the RPV flag" do
          before { patient.update(send_to_rpv: true) }

          context "when they also have changed since the last export date" do
            before { patient.update(sent_to_ukrdc_at: 1.day.ago, updated_at: 1.hour.ago, by: user) }

            it { is_expected.to eq([patient]) }
          end

          context "when they haven't changed since the last export date" do
            before { patient.update(sent_to_ukrdc_at: 1.day.ago, updated_at: 2.days.ago, by: user) }

            it { is_expected.to be_empty }
          end
        end

        describe "patient recently opted out of RPV" do
          context "when a patient does not have the RPV flag" do
            before { patient.update(send_to_rpv: false) }

            context "when their updated_at has changed since the last export" do
              before do
                patient.update(sent_to_ukrdc_at: 1.day.ago, updated_at: 1.hour.ago, by: user)
              end

              it { is_expected.to be_empty }
            end
          end
        end
      end

      context "when :changed_since argument is specified" do
        subject { described_class.new.call(changed_since: 1.week.ago) }

        context "when there no patients with send_to_rpv set" do
          it { is_expected.to be_empty }
        end

        context "when a patient has the RPV flag" do
          before { patient.update(send_to_rpv: true) }

          context "when they have changed since the :changed_since date" do
            before { patient.update(sent_to_ukrdc_at: nil, updated_at: 4.days.ago, by: user) }

            it { is_expected.to eq([patient]) }
          end

          context "when they haven't changed since the :changed_since date" do
            before { patient.update(sent_to_ukrdc_at: nil, updated_at: 3.weeks.ago, by: user) }

            it { is_expected.to be_empty }
          end
        end
      end
    end
  end
end
