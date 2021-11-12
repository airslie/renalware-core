class AddExternalDocumentTypeToEvents < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column(
        :event_types,
        :external_document_type_code,
        :string,
        comment: "A code eg 'MDT' used as metadata when renderimg the event to a PDF"
      )
      add_column(
        :event_types,
        :external_document_type_description,
        :string,
        comment: "See comment for external_document_type_code"
      )
    end
  end
end
