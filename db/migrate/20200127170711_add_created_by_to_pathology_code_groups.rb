class AddCreatedByToPathologyCodeGroups < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      change_table :pathology_code_groups do |t|
        t.references :created_by, foreign_key: { to_table: :users }, index: true, null: true
        t.references :updated_by, foreign_key: { to_table: :users }, index: true, null: true
      end

      change_table :pathology_code_group_memberships do |t|
        t.references :created_by, foreign_key: { to_table: :users }, index: true, null: true
        t.references :updated_by, foreign_key: { to_table: :users }, index: true, null: true
      end
    end
  end
end
