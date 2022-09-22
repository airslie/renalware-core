# frozen_string_literal: true

require "rails_helper"

describe Renalware::HD::Sessions::PreviousSessionDatesComponent, type: :component do
  let(:patient) { create(:hd_patient) }
  let(:instance) { described_class.new(patient: patient) }

  describe "#previous_sessions" do
    let(:second_patient) { create(:hd_patient) }

    context "when sessions exist" do
      let!(:another_patient_session) {
        create(:hd_session, patient: second_patient, started_at: 1.day.ago)
      }
      let!(:older_session) {
        create(:hd_session, patient: patient, started_at: 2.weeks.ago)
      }
      let!(:newer_session) {
        create(:hd_session, patient: patient, started_at: 1.week.ago)
      }

      it "returns last sessions in started at order" do
        expect(instance.previous_sessions).to eq \
          [
            newer_session,
            older_session
          ]
      end
    end

    context "with no sessions" do
      it "returns empty" do
        expect(instance.previous_sessions).to eq []
      end
    end
  end

  describe "#render" do
    context "when a session exists" do
      let(:start_date) { 1.week.ago - 6.days }
      let!(:session) { create(:hd_session, patient: patient, started_at: start_date) }

      it "renders a list of previous sessions" do
        render_inline(instance)

        expect(page).to have_content(session.started_at.strftime("%d-%b"))
      end
    end

    context "with no sessions" do
      it "renders nothing" do
        render_inline(instance)
        expect(page.text).to eq ""
      end
    end
  end
end
