class AddFilenamePrefixToEventTypes < ActiveRecord::Migration[5.2]
  def change
    add_column :event_types, :save_pdf_to_electronic_public_register, :boolean, null: false, default: 0
    add_column :event_types, :title, :string
  end
end
