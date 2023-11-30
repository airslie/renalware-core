class CreateDuplicateNHSNumbersReport < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      within_renalware_schema do
        create_view :duplicate_nhs_numbers

        attrs = {
          schema_name: "renalware",
          view_name: "duplicate_nhs_numbers",
          slug: "all",
          scope: :patients,
          category: "report",
          title: "Duplicate NHS numbers",
          sub_category: "Housekeeping",
          description: "Patients sharing an NHS number",
          patient_landing_page: :demographics
        }

        reversible do |direction|
          direction.up do
            Renalware::System::ViewMetadata.create_or_find_by!(attrs)
          end
          direction.down do
            Renalware::System::ViewMetadata.find_by(
              schema_name: "renalware",
              view_name: "duplicate_nhs_numbers"
            )&.destroy
          end
        end
      end
    end
  end
end
