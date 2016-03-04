class CreatePathologyObservationRequests < ActiveRecord::Migration
  def change
    create_table :pathology_observation_requests do |t|
      t.string :pcs_code
      t.string :requestor_name
      t.datetime :observed_at

      t.timestamps null: false
    end
  end
end
