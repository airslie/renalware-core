# rubocop:disable Style/RescueModifier
class ChangePathRequestConsultantId < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      remove_reference(
        :pathology_requests_requests,
        :consultant,
        foreign_key: { to_table: :users },
        index: true
      ) rescue nil # I have seen this fail on certain datasets, not sure why, hence the rescue.

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
# rubocop:enable Style/RescueModifier
