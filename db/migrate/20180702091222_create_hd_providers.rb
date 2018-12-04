class CreateHDProviders < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      create_table "renalware.hd_providers" do |t|
        t.string :name
        t.timestamps null: false
      end
    end
  end
end
