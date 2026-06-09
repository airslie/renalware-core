class AddClinicalCodesResponseToHeidiSessions < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      # add_column :heidi_sessions, :clinical_codes_response, :jsonb, null: false, default: {}
    end
  end
end
