class CreatePathologyObservationGroups < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_table :pathology_observation_groups do |t|
        t.string :name, null: false, index: { unique: true }
        t.timestamps null: false
      end

      create_table :pathology_observation_group_memberships do |t|
        t.references :group, null: false, foreign_key: { to_table: :pathology_observation_groups }
        t.references :description, null: false, foreign_key: { to_table: :pathology_observation_descriptions }
        t.integer :sub_group, null: false, default: 1, index: true
        t.integer :position, null: false, default: 1, index: true
        t.timestamps null: false
      end

      add_index(
        :pathology_observation_group_memberships,
        %i(group_id description_id),
        unique: true,
        name: :index_pathology_observation_group_memberships_uniq
      )
    end
  end
end
