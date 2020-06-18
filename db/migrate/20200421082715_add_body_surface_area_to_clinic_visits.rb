class AddBodySurfaceAreaToClinicVisits < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :clinic_visits, :body_surface_area, :decimal, precision: 8, scale: 2
      add_column :clinic_visits, :total_body_water, :decimal, precision: 8, scale: 2
    end
  end
end
