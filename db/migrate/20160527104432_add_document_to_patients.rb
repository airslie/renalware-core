class AddDocumentToPatients < ActiveRecord::Migration[4.2]
  def change
    add_column :patients, :document, :jsonb
    add_index :patients, :document, using: :gin
  end
end
