class AddCovid19ToPatientAlerts < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :patient_alerts, :covid_19, :boolean, null: false, default: false
    end
  end
end
