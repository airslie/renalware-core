class ValidateHeidiSessionsClinicVisitForeignKey < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      validate_foreign_key(
        :heidi_sessions,
        :clinic_visits
      )
    end
  end
end
