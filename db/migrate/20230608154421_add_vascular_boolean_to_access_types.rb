class AddVascularBooleanToAccessTypes < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      add_column :access_types, :hd_vascular, :boolean, default: true, null: false
    end
  end
end
