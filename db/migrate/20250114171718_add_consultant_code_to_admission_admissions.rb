class AddConsultantCodeToAdmissionAdmissions < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      add_column :admission_admissions, :consultant_code, :string
    end
  end
end
