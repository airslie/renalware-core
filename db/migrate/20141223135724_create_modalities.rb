class CreateModalities < ActiveRecord::Migration
  def change
    create_table :modalities do |t|
      t.references :patient,       null: false, foreign_key: true
      t.belongs_to :description,   null: false, index: true
      t.belongs_to :reason,        index: true
      t.string :modal_change_type
      t.text :notes
      t.date :started_on,          null: false
      t.date :ended_on
      t.datetime :deleted_at
      t.timestamps
    end
    add_foreign_key :modalities,
      :modality_descriptions, column: :description_id
    add_foreign_key :modalities,
      :modality_reasons, column: :reason_id
  end
end
