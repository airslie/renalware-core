class AddViewCountToSystemHelp < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :system_help, :view_count, :integer, default: 0, null: false
    end
  end
end
