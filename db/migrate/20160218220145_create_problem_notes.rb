class CreateProblemNotes < ActiveRecord::Migration
  def change
    create_table :problem_notes do |t|
      t.belongs_to :problem, index: true
      t.text :description, null: false
      t.boolean :show_in_letter
      t.boolean :show_in_clinical_summary

      t.belongs_to :created_by, index: true, null: false
      t.belongs_to :updated_by, index: true, null: false

      t.timestamps null: false
    end

    add_foreign_key :problem_notes, :problem_problems, column: :problem_id
  end
end
