class ChangePathRequestConsultantId < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      remove_column(:pathology_requests_requests, :consultant_id, :integer)

      add_reference(
        :pathology_requests_requests,
        :consultant,
        foreign_key: { to_table: :renal_consultants },
        index: true,
        null: true
      )
    end
  end
end
