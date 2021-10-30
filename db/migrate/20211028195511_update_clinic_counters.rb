class UpdateClinicCounters < ActiveRecord::Migration[5.2]
  def change
    Renalware::Clinics::Clinic.find_each do |clinic|
      Renalware::Clinics::Clinic.reset_counters(clinic.id, :clinic_visits)
      Renalware::Clinics::Clinic.reset_counters(clinic.id, :appointments)
    end
  end
end
