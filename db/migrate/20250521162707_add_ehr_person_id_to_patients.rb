class AddEhrPersonIdToPatients < ActiveRecord::Migration[8.0]
  def change
    within_renalware_schema do
      add_column(
        :patients,
        :ehr_person_identifier,
        :string,
        comment: "For use with an EHR eg Millennium. This is a unique identifier for the patient " \
                 "in the EHR system, and maybe be populated during the HL7 ingestion that " \
                 "creates the patient. SHould not be searchable from, or displayed in, the UI."
      )
      safety_assured do
        add_index(:patients, :ehr_person_identifier, unique: true)
      end
    end
  end
end
