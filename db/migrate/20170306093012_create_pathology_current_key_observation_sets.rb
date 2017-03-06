class CreatePathologyCurrentKeyObservationSets < ActiveRecord::Migration
  def change
    create_view :pathology_current_key_observation_sets
  end
end
