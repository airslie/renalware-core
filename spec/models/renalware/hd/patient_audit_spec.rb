module Renalware
  module HD
    describe PatientAudit, focus: true do
      let(:patient) { create(:hd_patient) }
      subject(:audit) { PatientAudit.new(patient) }

      it "exists" do
      end
    end
  end
end
