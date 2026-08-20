class MigrateODSSyncToDSE < ActiveRecord::Migration[7.1]
  def up
    within_renalware_schema do
      add_column :patient_practices, :ods_managed, :boolean, default: false, null: false
      add_column :patient_primary_care_physicians,
                 :ods_managed,
                 :boolean,
                 default: false,
                 null: false
      add_column :patient_practice_memberships,
                 :ods_managed,
                 :boolean,
                 default: false,
                 null: false

      # Before this column existed all non-default memberships were reconciled from ODS.
      # Preserve that behaviour while protecting locally created default memberships.
      safety_assured do
        execute <<~SQL.squish
          UPDATE patient_practice_memberships
          SET ods_managed = true
          WHERE default_gp = false
        SQL
      end

      create_table :feed_practices do |t| # rubocop:disable Rails/CreateTableWithTimestamps
        t.text :code, null: false, index: { unique: true }
        t.text :name, null: false
        t.text :telephone
        t.text :street_1
        t.text :street_2
        t.text :street_3
        t.text :town
        t.text :county
        t.text :postcode
        t.string :status, null: false
      end

      load_function("import_feed_practices_v01.sql")
      load_function("import_feed_gps_v02.sql")
      load_function("import_feed_practice_gps_v03.sql")
      safety_assured { update_manual_import_links_to_dse }
    end
  end

  def down
    within_renalware_schema do
      load_function("import_feed_gps_v01.sql")
      load_function("import_feed_practice_gps_v02.sql")
      safety_assured { restore_manual_import_links_to_trud }
      execute "DROP FUNCTION IF EXISTS renalware.import_feed_practices()"
      drop_table :feed_practices
      remove_column :patient_practice_memberships, :ods_managed
      remove_column :patient_primary_care_physicians, :ods_managed
      remove_column :patient_practices, :ods_managed
    end
  end

  private

  def update_manual_import_links_to_dse
    execute <<~SQL.squish
      UPDATE feed_file_types
      SET prompt = 'Upload the egpcur CSV report from NHS ODS Data Search and Export',
          download_url_title = 'Download current egpcur CSV',
          download_url =
            'https://www.odsdatasearchandexport.nhs.uk/api/getReport?report=egpcur',
          filename_validation_pattern = '/egpcur\\.(csv|zip)/i',
          updated_at = CURRENT_TIMESTAMP
      WHERE name = 'primary_care_physicians'
    SQL

    execute <<~SQL.squish
      UPDATE feed_file_types
      SET prompt = 'Upload the epracmem CSV report from NHS ODS Data Search and Export',
          download_url_title = 'Download current epracmem CSV',
          download_url =
            'https://www.odsdatasearchandexport.nhs.uk/api/getReport?report=epracmem',
          filename_validation_pattern = '/epracmem\\.(csv|zip)/i',
          updated_at = CURRENT_TIMESTAMP
      WHERE name = 'practice_memberships'
    SQL
  end

  def restore_manual_import_links_to_trud
    execute <<~SQL.squish
      UPDATE feed_file_types
      SET prompt =
            'Upload egpcur.zip from NHS ODS weekly data downloaded from the NHS TRUD site',
          download_url_title = 'egpcur.zip Current GP',
          download_url =
            'https://isd.digital.nhs.uk/trud3/user/authenticated/group/0/pack/5/subpack/58/releases',
          filename_validation_pattern = '/egpcur.zip/i',
          updated_at = CURRENT_TIMESTAMP
      WHERE name = 'primary_care_physicians'
    SQL

    execute <<~SQL.squish
      UPDATE feed_file_types
      SET prompt =
            'Upload epracmem.zip from NHS ODS weekly data downloaded from the NHS TRUD site',
          download_url_title = 'ODS Weekly data on NHS TRUD',
          download_url =
            'https://isd.digital.nhs.uk/trud3/user/authenticated/group/0/pack/5/subpack/58/releases',
          filename_validation_pattern = '/epracmem.zip/i',
          updated_at = CURRENT_TIMESTAMP
      WHERE name = 'practice_memberships'
    SQL
  end
end
