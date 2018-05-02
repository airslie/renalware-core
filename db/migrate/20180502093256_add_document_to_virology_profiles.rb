class AddDocumentToVirologyProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :virology_profiles,
               :document,
               :jsonb,
               default: {},
               null: false
    add_index :virology_profiles, :document, using: :gin
  end
end
