class CreatePathologyObservationDescriptions < ActiveRecord::Migration
  def change
    create_table :pathology_observation_descriptions do |t|
      t.string :code, null: false
    end
  end
end
