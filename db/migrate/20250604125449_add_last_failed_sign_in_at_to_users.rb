class AddLastFailedSignInAtToUsers < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      add_column :users, :last_failed_sign_in_at, :datetime
    end
  end
end
