class CreateAccessAssessments < ActiveRecord::Migration
  def change
    create_table :access_assessments do |t|
      t.belongs_to :patient, index: true, foreign_key: true

      t.references :type, null: false
      t.references :site, null: false
      t.string :side, null: false
      t.date :performed_on, null: false
      t.date :procedure_on
      t.text :comments

      t.belongs_to :created_by, index: true, null: false
      t.belongs_to :updated_by, index: true, null: false

      t.jsonb :document

      t.timestamps null: false
    end

    add_index :access_assessments, :document, using: :gin

    add_foreign_key :access_assessments, :access_types, column: :type_id
    add_foreign_key :access_assessments, :access_sites, column: :site_id
  end
end
