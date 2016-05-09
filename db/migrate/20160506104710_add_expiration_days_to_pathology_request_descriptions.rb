class AddExpirationDaysToPathologyRequestDescriptions < ActiveRecord::Migration
  def change
    add_column :pathology_request_descriptions, :expiration_days, :integer
  end
end
