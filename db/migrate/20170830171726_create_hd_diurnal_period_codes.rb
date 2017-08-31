class CreateHDDiurnalPeriodCodes < ActiveRecord::Migration[5.1]
  def change
    create_table :hd_diurnal_period_codes do |t|
      t.string :code, null: false
      t.text :description, null: true
    end

    add_index :hd_diurnal_period_codes, :code, unique: true
  end
end
