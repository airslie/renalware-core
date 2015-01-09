class CreateEsrfInfos < ActiveRecord::Migration
  def change
    create_table :esrf_infos do |t|

      t.timestamps null: false
    end
  end
end
