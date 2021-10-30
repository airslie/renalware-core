class UpdateConsultantCounterCache < ActiveRecord::Migration[5.2]
  def change
    Renalware::Clinics::Consultant.find_each do |consultant|
      Renalware::Clinics::Consultant.reset_counters(consultant.id, :appointments)
    end
  end
end
