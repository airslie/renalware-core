class AddLanguageToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :language, :string
  end
end
