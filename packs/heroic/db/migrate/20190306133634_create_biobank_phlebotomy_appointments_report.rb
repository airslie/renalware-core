class CreateBiobankPhlebotomyAppointmentsReport < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema(suffix: :heroic) do
      create_view :report_biobank_phlebotomy_appointments
    end
  end
end
