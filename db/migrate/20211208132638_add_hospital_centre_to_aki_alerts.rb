class AddHospitalCentreToAKIAlerts < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_reference :renal_aki_alerts, :hospital_centre, index: true, foreign_key: true
    end
  end
end
