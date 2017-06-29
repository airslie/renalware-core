class CreatePathologyCurrentKeyObservationSets < ActiveRecord::Migration[5.0]
  def change
    create_view :pathology_current_key_observation_sets
  end
end
