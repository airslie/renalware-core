class AddDocumentToEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :document, :jsonb
  end
end
