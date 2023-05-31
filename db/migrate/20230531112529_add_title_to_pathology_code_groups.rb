class AddTitleToPathologyCodeGroups < ActiveRecord::Migration[7.0]
  def change
    add_column :pathology_code_groups, :title, :string, index: { unique: true }
    add_column :pathology_code_groups, :context_specific, :boolean, default: false, null: false
  end
end
