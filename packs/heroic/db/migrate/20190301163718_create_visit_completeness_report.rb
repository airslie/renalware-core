class CreateVisitCompletenessReport < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema(suffix: :heroic) do
      create_table :report_definitions do |t|
        t.string :name, index: true, null: false
        t.string :description
        t.string :report_view_name, null: false
        t.integer :position, default: 999, null: false
        t.timestamps null: false
      end
      # A helper view to aggregate basic heroic patient data
      create_view :heroic_participants
      create_view :report_participants_with_missing_data
    end
  end
end
