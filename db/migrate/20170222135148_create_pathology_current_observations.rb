class CreatePathologyCurrentObservations < ActiveRecord::Migration[5.0]
  def change
    create_view :pathology_current_observations
  end
end
