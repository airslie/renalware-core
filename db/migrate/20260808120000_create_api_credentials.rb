class CreateAPICredentials < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      create_table :api_credentials do |t|
        t.references :user, null: false, foreign_key: true, index: true
        t.string :name, null: false
        t.string :token_digest, null: false
        t.string :token_prefix, null: false
        t.string :scopes, array: true, default: [], null: false
        t.boolean :enabled, default: true, null: false
        t.datetime :expires_at
        t.datetime :last_used_at

        t.timestamps null: false
      end

      add_index :api_credentials, :token_digest, unique: true
      add_index :api_credentials, %i(user_id name), unique: true
    end
  end
end
