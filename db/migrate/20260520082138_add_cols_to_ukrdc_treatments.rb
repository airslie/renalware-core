class AddColsToUKRDCTreatments < ActiveRecord::Migration[8.1]
  def change
    within_renalware_schema do
      safety_assured do
        add_reference(
          :ukrdc_treatments,
          :source_hospital_centre,
          index: true,
          foreign_key: { to_table: "hospital_centres" },
          comment: "Source hospital when modality is transferred in."
        )

        add_reference(
          :ukrdc_treatments,
          :destination_hospital_centre,
          index: true,
          foreign_key: { to_table: "hospital_centres" },
          comment: "Destination hospital when modality is transferred out."
        )
      end
    end
  end
end
