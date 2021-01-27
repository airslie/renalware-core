class AddSubtypeIdToEvents < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_reference(
        :events,
        :subtype,
        foreign_key: { to_table: :event_subtypes },
        index: true,
        null: true
      )
    end
  end
end
