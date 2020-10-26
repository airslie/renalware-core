class AddBMIToClinicVisits < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column(
        :clinic_visits,
        :bmi,
        :decimal,
        precision: 4,
        scale: 1,
        null: true,
        comment: "Body Mass Index calculated using a before_save when the clinic visit is updated"
      )

      reversible do |direction|
        direction.up do
          connection.execute(
            "update renalware.clinic_visits "\
            "set bmi = round(((weight / height)::decimal / height::decimal), 1) "\
            "where height > 0 and weight > 0;"
          )
        end
        direction.down do
          # noop
        end
      end
    end
  end
end
