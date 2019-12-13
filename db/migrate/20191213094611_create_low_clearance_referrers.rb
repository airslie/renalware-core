class CreateLowClearanceReferrers < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_table :low_clearance_referrers do |t|
        t.string :name, null: false, index: { unique: true }
        t.boolean :hidden, null: false, default: false
        t.timestamps null: false
      end

      add_reference(
        :low_clearance_profiles,
        :referrer,
        references: :low_clearance_referrers,
        index: true,
        null: true
      )

      add_foreign_key :low_clearance_profiles, :low_clearance_referrers, column: :referrer_id
    end
  end
end
