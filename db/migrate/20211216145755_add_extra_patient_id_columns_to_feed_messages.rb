class AddExtraPatientIdColumnsToFeedMessages < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column(
        :feed_messages, :patient_identifiers,
        :jsonb,
        default: {},
        null: false
      )
      add_index :feed_messages, :patient_identifiers, using: :gin
    end
  end
end
