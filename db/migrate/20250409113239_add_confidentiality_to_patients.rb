class AddConfidentialityToPatients < ActiveRecord::Migration[8.0]
  def change
    within_renalware_schema do
      safety_assured do
        create_enum :enum_confidentiality, %w(normal restricted)

        change_table :patients do |t|
          t.enum :confidentiality,
                 enum_type: :enum_confidentiality,
                 null: false,
                 default: "normal",
                 comment: "Correspondence will not be sent via GP Connect if set to restricted"
        end
      end
    end
  end
end
