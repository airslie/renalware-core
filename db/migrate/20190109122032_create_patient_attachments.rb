class CreatePatientAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :patient_attachments do |t|
      t.references :patient, foreign_key: true, index: true, null: false
      t.references(
        :attachment_type,
        foreign_key: { to_table: :patient_attachment_types },
        index: true,
        null: false
      )
      t.string :name, index: true
      t.text :description
      t.string :external_location
      t.references :updated_by, foreign_key: { to_table: :users }, index: true
      t.references :created_by, foreign_key: { to_table: :users }, index: true
      t.date :document_date, index: true
      t.datetime :deleted_at, index: true
      t.timestamps null: false
    end
  end
end
