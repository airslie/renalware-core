class CreatePrdCodes < ActiveRecord::Migration
  def change
    create_table :prd_codes do |t|

      t.timestamps null: false
    end
  end
end
