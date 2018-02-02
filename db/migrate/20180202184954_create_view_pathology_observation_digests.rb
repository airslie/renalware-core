class CreateViewPathologyObservationDigests < ActiveRecord::Migration[5.1]
  def change
    create_view :pathology_observation_digests
  end
end
