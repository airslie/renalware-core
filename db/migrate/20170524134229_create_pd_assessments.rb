class CreatePDAssessments < ActiveRecord::Migration[5.0]
  def change
    create_table :pd_assessments do |t|
      t.references :patient, null: false, foreign_key: true, index: true
      t.jsonb :document
      t.references :created_by, index: true, null: false
      t.references :updated_by, index: true, null: false
      t.timestamps null: true
    end

    add_foreign_key :pd_assessments, :users, column: :created_by_id
    add_foreign_key :pd_assessments, :users, column: :updated_by_id
  end
end
