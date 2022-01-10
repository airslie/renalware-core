class CreatePatientWorryCategories < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_table :patient_worry_categories do |t|
        t.string :name, null: false
        t.integer(
          :worries_count,
          null: false,
          default: 0,
          comment: "Counter cache for the number of worries with this category"
        )
        t.datetime :deleted_at, index: true
        t.references :created_by, foreign_key: { to_table: :users }, null: false
        t.references :updated_by, foreign_key: { to_table: :users }, null: false
        t.timestamps null: false
      end

      add_index(
        :patient_worry_categories,
        :name,
        unique: true,
        where: "deleted_at IS NULL",
        comment: "Disallow duplicate undeleted names"
      )

      change_table :patient_worries do |t|
        t.references(
          :worry_category,
          null: true,
          index: true,
          foreign_key: { to_table: :patient_worry_categories }
        )
      end
    end
  end
end
