class AddAuthenticationTokenToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :authentication_token, :string, index: { unique: true }
  end
end
