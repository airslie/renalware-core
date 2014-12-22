class CreateModalityCodes < ActiveRecord::Migration
  def change
    create_table :modality_codes do |t|

      t.timestamps
    end
  end
end
