class CreateProblemMalignancySites < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      create_table :problem_malignancy_sites do |t|
        t.text :description, null: false, index: { unique: true }
        t.string :rr_19_code, comment: "Renal Registry dataset v5 RR19 code"
      end
    end
  end
end
