class AddHiddenColumToEventTypes < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :event_types, :hidden, :boolean, null: false, default: false, index: true
    end
  end
end
