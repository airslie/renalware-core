class CreatePathologyCurrentObservations < ActiveRecord::Migration
  def change
    create_view :pathology_current_observations
  end
end
