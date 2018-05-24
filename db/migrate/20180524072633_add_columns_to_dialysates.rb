class AddColumnsToDialysates < ActiveRecord::Migration[5.1]
  def change
    add_column :hd_dialysates, :bicarbonate_content, :decimal, precision: 10, scale: 2
    add_column :hd_dialysates, :bicarbonate_content_uom, :string, default: "mmol/L"

    add_column :hd_dialysates, :calcium_content, :decimal, precision: 10, scale: 2
    add_column :hd_dialysates, :calcium_content_uom, :string, default: "mmol/L"

    add_column :hd_dialysates, :glucose_content, :decimal, precision: 10, scale: 2
    add_column :hd_dialysates, :glucose_content_uom, :string, default: "g/L"

    add_column :hd_dialysates, :potassium_content, :decimal, precision: 10, scale: 2
    add_column :hd_dialysates, :potassium_content_uom, :string, default: "mmol/L"
  end
end
