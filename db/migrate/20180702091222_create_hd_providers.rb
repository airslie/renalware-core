class CreateHDProviders < ActiveRecord::Migration[5.1]
  def change
    create_table "renalware.hd_providers" do |t|
      t.string :name
      t.timestamps null: false
    end
  end
end
