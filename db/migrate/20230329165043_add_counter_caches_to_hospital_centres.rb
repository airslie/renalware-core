class AddCounterCachesToHospitalCentres < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      add_column(
        :hospital_centres,
        :departments_count,
        :integer,
        default: 0,
        null: false,
        comment: "Counter cache for the number of departments at this centre"
      )
      add_column(
        :hospital_centres,
        :units_count,
        :integer,
        default: 0,
        null: false,
        comment: "Counter cache for the number of units at this centre"
      )
    end
  end
end
