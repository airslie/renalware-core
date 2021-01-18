class CreateEventTypeAlertTriggers < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_table(
        :event_type_alert_triggers,
        comment: "Matching alerts are displayed on patient pages"
      ) do |t|
        t.references :event_type, foreign_key: true, null: false
        t.text :when_event_document_contains
        t.text :when_event_description_contains
        t.timestamps null: false
      end
    end
  end
end
