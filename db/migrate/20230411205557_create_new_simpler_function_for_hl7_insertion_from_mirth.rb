class CreateNewSimplerFunctionForHL7InsertionFromMirth < ActiveRecord::Migration[7.0]
  def up
    within_renalware_schema do
      load_function "insert_raw_hl7_message_v01.sql"
    end
  end

  def down
    within_renalware_schema do
      connection.execute("DROP FUNCTION IF EXISTS insert_raw_hl7_message")
    end
  end
end
