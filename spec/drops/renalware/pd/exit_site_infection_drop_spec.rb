require "rails_helper"

module Renalware::PD
  RSpec.describe ExitSiteInfectionDrop, type: :model do
    let(:patient) { build(:patient) }
    let(:esi) { build(:exit_site_infection, patient: patient) }

    subject { ExitSiteInfectionDrop.new(esi) }

    it "delegates to #date" do
      expect(subject.date).to eq(I18n.l(esi.diagnosis_date))
    end

    describe "organisms" do
      it "concats all organisms into a string" do
        organism_code1 = build(:organism_code, name: "A")
        organism_code2 = build(:organism_code, name: "B")
        organisms = [
          build(:infection_organism, infectable: esi, organism_code: organism_code1),
          build(:infection_organism, infectable: esi, organism_code: organism_code2)
        ]
        expect(esi).to receive(:infection_organisms).and_return(organisms)
        expect(subject.organisms).to eq("A, B")
      end
    end
  end
end
