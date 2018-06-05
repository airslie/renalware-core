class CreatePseudoEncryptFunction < ActiveRecord::Migration[5.1]
  class CreateCountEstimateFunction < ActiveRecord::Migration[5.1]
    def up
      load_function "pseudo_encrypt_v01.sql"
    end

    def down
      connection.execute("DROP FUNCTION renalware.pseudo_encrypt(int);")
    end
  end
end
