class RemoveGeneratedOutputsFromHeidiSessions < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      safety_assured do
        remove_column :heidi_sessions, :document_template_id, :string
        remove_column :heidi_sessions, :document_content_type, :string
        remove_column :heidi_sessions, :document_content, :text
        remove_column :heidi_sessions, :document_response, :jsonb, null: false, default: {}
        remove_column :heidi_sessions, :structured_response, :jsonb, null: false, default: {}
        remove_column :heidi_sessions, :clinical_codes_response, :jsonb, null: false, default: {}
        remove_column :heidi_sessions, :outputs_generated_at, :datetime
        remove_column :heidi_sessions, :outputs_error, :text
      end
    end
  end
end
