module Renalware
  module Modalities
    describe DescriptionSelectOptions do
      describe ".list_for_dropdown" do
        it "includes visible modalities with their codes and excludes hidden modalities" do
          description = create(:modality_description, :transfer_out)
          create(:modality_description, name: "Hidden modality", hidden: true)

          expect(described_class.list_for_dropdown).to eq(
            [[description.name, description.id, { data: { code: "transfer_out" } }]]
          )
        end
      end
    end
  end
end
