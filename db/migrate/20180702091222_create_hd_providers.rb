class CreateHDProviders < ActiveRecord::Migration[5.1]
  def change
    create_table :hd_providers do |t|
      t.string :name
    end
  end
end
