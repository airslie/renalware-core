# frozen_string_literal: true

require "rails_helper"

describe Renalware::ApplicationHelper, type: :helper do
  describe ".default_patient_link" do
    it "creates a link going to the patient's clinical summary" do
      patient = build_stubbed(:patient)

      expect(helper.default_patient_link(patient))
        .to match(/#{patient_clinical_summary_path(patient)}/)
    end
  end

  describe ".warning_and_error_flash_messages" do
    it "returns alert e" do
      allow(helper).to receive(:flash).and_return(
        alert: [:alert_message],
        notice: [:notice_message],
        success: [:success_message],
        warning: [:warning_message],
        timedout: [true]
      )
      expect(helper.warning_and_error_flash_messages).to eq(
        alert: [:alert_message],
        warning: [:warning_message]
      )
    end
  end

  describe ".success_flash_messages" do
    it "returns alert and notice and success flash message" do
      allow(helper).to receive(:flash).and_return(
        alert: [:alert_message],
        notice: [:notice_message],
        success: [:success_message],
        warning: [:warning_message],
        timedout: [true]
      )
      expect(helper.success_flash_messages).to eq(
        notice: [:notice_message],
        success: [:success_message]
      )
    end
  end
end
