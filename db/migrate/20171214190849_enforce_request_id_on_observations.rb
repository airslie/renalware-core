class EnforceRequestIdOnObservations < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      change_column_null :pathology_observations, :request_id, false
    end
  end
end
