class CreateViewPathologyObservationDigests < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      create_view :pathology_observation_digests
    end
  end
end
