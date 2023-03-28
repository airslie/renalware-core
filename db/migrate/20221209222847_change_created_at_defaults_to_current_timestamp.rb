class ChangeCreatedAtDefaultsToCurrentTimestamp < ActiveRecord::Migration[6.0]
  def change
    change_column_default :drugs, :created_at, from: nil, to: -> { "CURRENT_TIMESTAMP" }

    change_column_default :medication_routes, :created_at,
                          from: nil, to: -> { "CURRENT_TIMESTAMP" }
  end
end
