class CreatePatientAttachmentTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :patient_attachment_types do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :description
      t.boolean :store_file_externally, null: false, default: false
      t.datetime :deleted_at, index: true
      t.timestamps null: false
    end
  end
end
