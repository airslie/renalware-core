class AddNHSBTStatusToTransplantRegistrationStatusDescriptions < ActiveRecord::Migration[8.1]
  def up
    within_renalware_schema do
      create_table :transplant_registration_nhsbt_status_descriptions do |t|
        t.string :code, null: false
        t.string :name, null: false
        t.timestamps
      end

      add_index :transplant_registration_nhsbt_status_descriptions,
                :code,
                unique: true,
                name: "idx_transplant_registration_nhsbt_statuses_on_code"

      safety_assured do
        add_column :transplant_registration_status_descriptions,
                   :nhsbt_status_code,
                   :string,
                   comment: "NHSBT transplant registration status code"

        add_foreign_key :transplant_registration_status_descriptions,
                        :transplant_registration_nhsbt_status_descriptions,
                        column: :nhsbt_status_code,
                        primary_key: :code

        execute <<~SQL.squish
          INSERT INTO renalware.transplant_registration_nhsbt_status_descriptions
            (code, name, created_at, updated_at)
          VALUES
            ('A', 'Active', current_timestamp, current_timestamp),
            ('S', 'Suspended', current_timestamp, current_timestamp),
            ('R', 'Removed', current_timestamp, current_timestamp),
            ('T', 'Transplanted', current_timestamp, current_timestamp),
            ('W', 'Work-up', current_timestamp, current_timestamp)
          ON CONFLICT (code) DO NOTHING
        SQL

        {
          active: "A",
          suspended: "S",
          transplanted: "T",
          live_transplanted: "T",
          off_by_patient: "R",
          not_eligible: "R",
          unfit_reconsider: "R",
          unfit_permanent: "R",
          working_up: "W",
          working_up_lrf: "W",
          not_for_work_up: "R",
          workup_complete: "W",
          transfer_out: "R",
          died: "R"
        }.each do |registration_status_code, nhsbt_status_code|
          execute <<~SQL.squish
            UPDATE renalware.transplant_registration_status_descriptions
            SET nhsbt_status_code = '#{nhsbt_status_code}'
            WHERE code = '#{registration_status_code}'
          SQL
        end
      end
    end
  end

  def down
    within_renalware_schema do
      remove_foreign_key :transplant_registration_status_descriptions,
                         column: :nhsbt_status_code
      remove_column :transplant_registration_status_descriptions, :nhsbt_status_code
      drop_table :transplant_registration_nhsbt_status_descriptions
    end
  end
end
