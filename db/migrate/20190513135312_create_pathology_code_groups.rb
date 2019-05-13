class CreatePathologyCodeGroups < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_table :pathology_code_groups do |t|
        t.string :name, null: false, index: { unique: true }
        t.text :description
        t.timestamps null: false
      end

      create_table :pathology_code_group_memberships do |t|
        t.references :code_group, null: false, foreign_key: { to_table: :pathology_code_groups }
        t.references :observation_description,
                     null: false,
                     foreign_key: { to_table: :pathology_observation_descriptions },
                     index: { name: :pathology_code_group_membership_obx }
        t.integer :subgroup, null: false, default: 1
        t.integer :position_within_subgroup, null: false, default: 1
        t.timestamps null: false
      end

      # Prevent the code appearing > once in any group
      add_index(
        :pathology_code_group_memberships,
        %i(code_group_id observation_description_id),
        unique: true,
        name: :index_pathology_code_group_memberships_uniq
      )
    end
  end
end
