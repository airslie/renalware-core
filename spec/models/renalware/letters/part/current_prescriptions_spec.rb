require "rails_helper"

module Renalware::Letters
  describe Part::CurrentPrescriptions do
    let(:patient) { spy(:patient) }
    subject(:part) { Part::CurrentPrescriptions.new(patient) }

    it "delegates to the patient's presented current prescriptions" do
      part.to_a

      expect(patient).to have_received(:prescriptions)
    end
  end
end
