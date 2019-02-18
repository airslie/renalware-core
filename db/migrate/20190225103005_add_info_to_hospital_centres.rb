class AddInfoToHospitalCentres < ActiveRecord::Migration[5.2]
  def change
    add_column :hospital_centres, :info, :text, null: true
    add_column :hospital_centres, :trust_name, :string, null: true
    add_column :hospital_centres, :trust_caption, :string, null: true
  end
end
