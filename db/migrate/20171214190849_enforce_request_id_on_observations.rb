class EnforceRequestIdOnObservations < ActiveRecord::Migration[5.1]
  def change
    change_column_null :pathology_observations, :request_id, false
  end
end
