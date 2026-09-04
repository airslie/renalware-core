class AddClinicVisitToHeidiSessions < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    within_renalware_schema do
      add_reference(
        :heidi_sessions,
        :clinic_visit,
        index: { algorithm: :concurrently }
      )

      add_foreign_key(
        :heidi_sessions,
        :clinic_visits,
        validate: false
      )
    end
  end
end
