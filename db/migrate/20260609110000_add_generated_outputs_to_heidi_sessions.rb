class AddGeneratedOutputsToHeidiSessions < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      safety_assured do
        change_table :heidi_sessions, bulk: true do |t|
          t.string :document_template_id
          t.string :document_content_type
          t.text :document_content
          t.jsonb :document_response, null: false, default: {}
          t.jsonb :structured_response, null: false, default: {}
          t.jsonb :clinical_codes_response, null: false, default: {}
          t.datetime :outputs_generated_at
          t.text :outputs_error
        end
      end
    end
  end
end
