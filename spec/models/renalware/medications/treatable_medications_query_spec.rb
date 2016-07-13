require 'rails_helper'

module Renalware::Medications
  RSpec.describe TreatableMedicationsQuery, :type => :model do

    let(:treatable) { create(:patient) }

    subject(:query) { TreatableMedicationsQuery.new(treatable: treatable) }

    let!(:current_medication) { create(:medication, patient: treatable, treatable: treatable) }
    let!(:terminated_medication) { create(:medication, :terminated, patient: treatable, treatable: treatable) }

    it "returns all current medications for a treatable target" do
      medications = subject.call

      expect(medications).to be_present
      expect(medications).to include(current_medication)
      expect(medications).not_to include(terminated_medication)
    end
  end
end
