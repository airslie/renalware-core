class AddPositionToAccessPlanTypes < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      within_renalware_schema do
        add_column(
          :access_plan_types,
          :position,
          :integer,
          default: 0,
          null: false
        )
        add_index :access_plan_types, :position
      end
    end
  end
end
