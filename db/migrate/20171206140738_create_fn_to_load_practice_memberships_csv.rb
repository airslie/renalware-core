class CreateFnToLoadPracticeMembershipsCSV < ActiveRecord::Migration[5.1]
  def up
    sql = <<-SQL
      CREATE OR REPLACE FUNCTION renalware.import_practice_memberships_csv(file text) RETURNS void
          AS $$
          BEGIN

          DROP TABLE IF EXISTS memberships_via_copy;
          CREATE TEMP TABLE copied_memberships (
            gp_code text NOT NULL,
            practice_code text NOT NULL,
            unused3 text,
            unused4 text,
            unused5 text,
            unused7 text
          );

          -- Import the CSV file into copied_memberships - note there is no CSV header in this file
          EXECUTE format ('COPY copied_memberships FROM %L DELIMITER %L CSV ', file, ',');

          DROP TABLE IF EXISTS tmp_memberships;
          CREATE TEMP TABLE tmp_memberships AS
            SELECT
              gp_code,
              practice_code,
              patient_primary_care_physicians.id primary_care_physician_id,
              patient_practices.id as practice_id
              from copied_memberships
              INNER JOIN patient_practices on patient_practices.code = practice_code
              INNER JOIN patient_primary_care_physicians on patient_primary_care_physicians.code = gp_code;

          -- Insert any new memberships, ignoring any conflicts where the
          -- practice_id + primary_care_physician_id already exists
          INSERT INTO renalware.patient_practice_memberships
            (practice_id, primary_care_physician_id, created_at, updated_at)
          SELECT
            practice_id,
            primary_care_physician_id,
            CURRENT_TIMESTAMP,
            CURRENT_TIMESTAMP
          FROM tmp_memberships
          ON CONFLICT (practice_id, primary_care_physician_id) DO NOTHING;

          -- Mark as deleted any memberships not in the latest uploaded data set - ie those gps have retired or moved on
          UPDATE patient_practice_memberships mem
            SET deleted_at = CURRENT_TIMESTAMP
            WHERE NOT EXISTS (select 1 FROM tmp_memberships tmem
            WHERE tmem.practice_id = mem.practice_id AND tmem.primary_care_physician_id = mem.primary_care_physician_id);

        END;
        $$ LANGUAGE plpgsql;
    SQL

    ActiveRecord::Base.connection.execute(sql)
  end

   def down
    ActiveRecord::Base.connection.execute(
      "DROP FUNCTION IF EXISTS import_practice_memberships_csv(file text);"
    )
  end
end
