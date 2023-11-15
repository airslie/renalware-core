class SupportSourceDestinationHospitalsInModalities < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      add_column(
        :hospital_centres,
        :position,
        :integer,
        null: false,
        default: 10,
        comment: "Allows us to float hard-to-find options like 'Other' and 'Non-UK' the top of " \
                 "of dropdown lists"
      )
      safety_assured do
        add_reference(
          :modality_modalities,
          :source_hospital_centre,
          index: true,
          foreign_key: { to_table: "hospital_centres" },
          comment: "Source hospital when modality is transferred in."
        )

        add_reference(
          :modality_modalities,
          :destination_hospital_centre,
          index: true,
          foreign_key: { to_table: "hospital_centres" },
          comment: "Destination hospital when modality is transferred out."
        )

        add_column(
          :modality_change_types,
          :require_source_hospital_centre,
          :boolean,
          null: false,
          default: false,
          comment: "When true, a source hospital must be chosen when adding the modality"
        )

        add_column(
          :modality_change_types,
          :require_destination_hospital_centre,
          :boolean,
          null: false,
          default: false,
          comment: "When true, a destination hospital must be chosen when adding the modality"
        )
      end
    end
  end
end
