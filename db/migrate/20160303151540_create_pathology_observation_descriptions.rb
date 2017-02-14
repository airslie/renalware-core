class CreatePathologyObservationDescriptions < ActiveRecord::Migration[4.2]
  def change
    create_table :pathology_observation_descriptions do |t|
      t.string :code, null: false
      t.string :name
    end
  end
end
