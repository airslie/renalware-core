class AddAbbreviationToAccessTypes < ActiveRecord::Migration
  def change
    add_column :access_types, :abbreviation, :string, null: true
  end
end
