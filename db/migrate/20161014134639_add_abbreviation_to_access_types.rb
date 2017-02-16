class AddAbbreviationToAccessTypes < ActiveRecord::Migration[4.2]
  def change
    add_column :access_types, :abbreviation, :string, null: true
  end
end
