class AddCreatedBySenderToPathologyObservationDescriptions < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      change_table :pathology_observation_descriptions do |t|
        t.references(
          :created_by_sender,
          foreign_key: { to_table: :pathology_senders },
          null: true,
          index: { name: :pathology_observation_descriptions_sender },
          comment: "The feed source that dynmically created this OBX"
        )
      end
    end
  end
end
