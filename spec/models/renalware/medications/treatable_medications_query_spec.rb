require 'rails_helper'

module Renalware::Medications
  RSpec.describe TreatableMedicationsQuery, :type => :model do

    let(:treatable) { create(:patient) }

    context "without a filter" do
      let!(:current_medication) { create(:medication, patient: treatable, treatable: treatable) }
      let!(:terminated_medication) { create(:medication, :terminated, patient: treatable, treatable: treatable) }

      subject(:query) { TreatableMedicationsQuery.new(treatable: treatable) }

      it "returns all current medications for a treatable target" do
        medications = query.call

        expect(medications).to include(current_medication)
        expect(medications).not_to include(terminated_medication)
      end
    end

    context "with a filter for drug type" do
      let(:target_drug_type) { create(:drug_type) }
      let(:target_drug) { create(:drug, drug_types: [target_drug_type] ) }
      let!(:target_medication) { create(:medication, patient: treatable, treatable: treatable, drug: target_drug) }

      let(:other_drug_type) { create(:drug_type) }
      let(:other_drug) { create(:drug, drug_types: [other_drug_type] ) }
      let!(:other_medication) { create(:medication, patient: treatable, treatable: treatable, drug: other_drug) }

      subject(:query) { TreatableMedicationsQuery.new(treatable: treatable) }

      xit "returns the current medications matching the specified drug type" do
        medications = query.call

        expect(medications).to include(target_medication)
        expect(medications).not_to include(other_medication)
      end
    end
  end
end
