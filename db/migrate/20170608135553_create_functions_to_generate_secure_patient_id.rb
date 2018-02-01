class CreateFunctionsToGenerateSecurePatientId < ActiveRecord::Migration[5.0]
  def up
    load_function("generate_secure_id_v01.sql")
    load_function("generate_patient_secure_id_v01.sql")
  end

  def down
    connection.execute(
      "DROP FUNCTION IF EXISTS generate_secure_id(integer); \
       DROP FUNCTION IF EXISTS generate_patient_secure_id();"
    )
  end
end
