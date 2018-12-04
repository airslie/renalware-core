class CreatePseudoEncryptFunction < ActiveRecord::Migration[5.1]
  def up
    within_renalware_schema do
      load_function "pseudo_encrypt_v01.sql"
    end
  end

  def down
    within_renalware_schema do
      connection.execute("DROP FUNCTION renalware.pseudo_encrypt(int);")
    end
  end
end
