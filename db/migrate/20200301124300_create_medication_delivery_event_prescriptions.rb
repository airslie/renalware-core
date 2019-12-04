class CreateMedicationDeliveryEventPrescriptions < ActiveRecord::Migration[5.2]
  def change
    # rubocop:disable Rails/CreateTableWithTimestamps
    within_renalware_schema do
      create_table(
        :medication_delivery_event_prescriptions,
        comment: "A cross reference table between delivery_events and prescriptions"
      ) do |t|
        t.references(
          :event,
          foreign_key: { to_table: :medication_delivery_events },
          index: false,
          null: false
        )
        t.references(
          :prescription,
          foreign_key: { to_table: :medication_prescriptions },
          index: false,
          null: false
        )
      end
      # rubocop:enable Rails/CreateTableWithTimestamps

      add_index(
        :medication_delivery_event_prescriptions,
        [
          :event_id,
          :prescription_id
        ],
        unique: true,
        name: :idx_medication_delivery_event_prescriptions
      )
    end
  end
end
