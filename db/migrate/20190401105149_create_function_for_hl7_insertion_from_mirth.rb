class CreateFunctionForHL7InsertionFromMirth < ActiveRecord::Migration[5.2]
  def up
    within_renalware_schema do
      load_function "new_hl7_message_v01.sql"
    end
  end

  def down
    within_renalware_schema do
      connection.execute("DROP FUNCTION new_hl7_message(text);")
    end
  end
end
