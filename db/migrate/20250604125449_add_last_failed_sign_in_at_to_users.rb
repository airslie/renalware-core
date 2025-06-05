class AddLastFailedSignInAtToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :last_failed_sign_in_at, :datetime
  end
end
