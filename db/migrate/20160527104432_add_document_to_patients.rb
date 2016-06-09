class AddDocumentToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :document, :jsonb
    add_index :patients, :document, using: :gin
  end
end
