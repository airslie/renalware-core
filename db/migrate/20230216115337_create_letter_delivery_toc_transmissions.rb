class CreateLetterDeliveryTocTransmissions < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      enable_extension "pgcrypto" unless extension_enabled?("pgcrypto")

      create_enum :toc_transmission_status, %w(
        pending
        success
        failure
      )

      create_table :letter_delivery_toc_transmissions  do |t|
        t.uuid(
          :uuid,
          default: "uuid_generate_v4()",
          null: false
        )
        t.references(
          :letter,
          foreign_key: { to_table: :letter_letters },
          index: true,
          null: false,
          comment: "A reference to the letter being sent"
        )
        t.enum(
          :status,
          enum_type: :toc_transmission_status,
          null: false,
          default: "pending"
        )
        t.timestamps null: false, index: true
      end
    end
  end
end
