class CreateLowClearanceDialysisPlans < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    within_renalware_schema do
      create_table :low_clearance_dialysis_plans do |t|
        t.string(
          :code,
          null: false,
          index: { unique: true },
          comment: "Required only for migration from the code-based enumeration"
        )
        t.string :name, null: false, index: { unique: true }
        t.datetime :deleted_at, index: true
        t.timestamps null: false
      end

      add_reference(
        :low_clearance_profiles,
        :dialysis_plan,
        references: :low_clearance_dialysis_plans,
        index: { algorithm: :concurrently }
      )
    end
  end
end
