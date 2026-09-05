# frozen_string_literal: true

module Renalware
  RSpec.describe Patients::TimelineComponent do
    subject { described_class.new(patient:, current_user:) }

    let(:sort_date) { Date.new(2025, 7, 9) }
    let(:patient) { create(:patient) }
    let(:current_user) { nil }
    let(:include_admission) { true }

    before do
      create(:admissions_admission, patient:, admitted_on: sort_date) if include_admission
    end

    it "renders component" do
      expect(fragment.text).to include("Activity Summary (1)")
      expect(fragment.text).to include("09-Jul-2025AdmissionUnknown")
      expect(fragment.text).to include("Ward A")
    end

    context "with safety alerts" do
      let(:patient) { create(:renal_patient, :minimal) }
      let(:include_admission) { false }
      let(:rule) do
        create(
          :renal_safety_alert_rule,
          name: "A safety alert rule name that is longer than forty characters"
        )
      end

      before do
        create(
          :renal_safety_alert,
          patient:,
          safety_alert_rule: rule,
          rule_name: rule.name,
          created_at: sort_date,
          notes: "Reviewed by consultant"
        )
        create(
          :renal_safety_alert,
          patient:,
          safety_alert_rule: create(:renal_safety_alert_rule, name: "Resolved alert"),
          rule_name: "Resolved alert",
          created_at: sort_date - 1.day,
          deleted_at: sort_date
        )
      end

      it "renders safety alerts" do
        expect(fragment.text).to include("Activity Summary (2)")
        expect(fragment.text).to include(
          "09-Jul-2025Safety AlertA safety alert rule name that is long...System User"
        )
        expect(fragment.text).to include(
          "08-Jul-2025Safety Alert (resolved)Resolved alertSystem User"
        )
        expect(fragment.text).to include("NotesReviewed by consultant")
        expect(fragment.text).to include("NotesNo notes recorded")
      end
    end
  end
end
