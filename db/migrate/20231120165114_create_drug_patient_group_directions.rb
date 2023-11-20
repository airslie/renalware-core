class CreateDrugPatientGroupDirections < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      comment = <<-COMMENT.squish
        Patient group directions (PGDs) are written instructions to help you supply or
        administer medicines to patients, usually in planned circumstances
        https://www.gov.uk/government/publications/patient-group-directions-pgds/
        patient-group-directions-who-can-use-them
      COMMENT
      create_table(:drug_patient_group_directions, comment: comment) do |t|
        t.string :name, null: false, comment: "E.g. Ceftriaxone INJECTION"
        t.string :code, comment: "E.g. DA/57"
        t.date :starts_on, comment: "The date the PGD is effective from e.g. Apr-24-2021"
        t.date :ends_on, comment: "The date the PGD is expires e.g. Apr-24-2024"
        t.integer :position, default: 0, null: false
        t.timestamps null: false
      end
    end
  end
end
