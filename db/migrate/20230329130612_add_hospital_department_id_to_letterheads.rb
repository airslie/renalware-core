class AddHospitalDepartmentIdToLetterheads < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      safety_assured do
        add_reference(
          :letter_letterheads,
          :hospital_department,
          foreign_key: { to_table: :hospital_departments },
          index: true,
          null: true
        )
      end
    end
  end
end
