class CreateResearchStudies < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      create_table :research_studies do |t|
        t.string :code, null: false
        t.string :description, null: false, index: true
        t.string :leader, index: true
        t.text :notes
        t.date :started_on
        t.date :terminated_on
        t.datetime :deleted_at
        t.references :updated_by, foreign_key: { to_table: :users }, index: true
        t.references :created_by, foreign_key: { to_table: :users }, index: true
        t.timestamps null: false
      end

      # This create a postgres partial index
      add_index :research_studies,
                :code,
                unique: true,
                where: "deleted_at IS NULL"
    end
  end
end
