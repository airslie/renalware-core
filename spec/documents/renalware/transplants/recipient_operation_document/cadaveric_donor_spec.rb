module Renalware
  module Transplants
    describe RecipientOperationDocument::CadavericDonor do
      describe "UKT cause of death" do
        it "stores the selected code unchanged and resolves its database name" do
          create(:transplant_ukt_death_cause, code: "brain_tumour", name: "Brain tumour")
          document = described_class.new(ukt_cause_of_death: "brain_tumour")

          expect(document.ukt_cause_of_death).to eq("brain_tumour")
          expect(document.ukt_cause_of_death_name).to eq("Brain tumour")
        end

        it "requires other text for causes which ask for more detail" do
          document = described_class.new(ukt_cause_of_death: "other")

          expect(document).not_to be_valid
          expect(document.errors[:ukt_cause_of_death_other]).to be_present
        end

        it "does not require other text for other causes" do
          document = described_class.new(ukt_cause_of_death: "brain_tumour")

          expect(document).to be_valid
        end
      end
    end
  end
end
