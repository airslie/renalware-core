class CreateEventCategories < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_table :event_categories do |t|
        t.string :name, null: false, index: { unique: true }
        t.integer :position, null: false, default: 10
        t.datetime :deleted_at, index: true
        t.timestamps null: false
      end

      add_reference(
        :event_types,
        :category,
        references: :event_categories,
        index: true,
        null: true,
        foreign_key: { to_table: :event_categories }
      )

      reversible do |direction|
        direction.up do
          category = Renalware::Events::Category.find_or_create_by!(name: "General")
          Renalware::Events::Type
            .with_deleted
            .where(category_id: nil)
            .update_all(category_id: category.id)
        end
        direction.down do
          # noop
        end
      end

      change_column_null(:event_types, :category_id, false)
    end
  end
end
