class AddPatientIdToVirologyProfile < ActiveRecord::Migration[5.1]
  # rubocop:disable Rails/NotNullColumn
  def change
    within_renalware_schema do
      add_reference :virology_profiles,
                    :patient,
                    foreign_key: true,
                    index: { unique: true },
                    null: false
    end
  end
  # rubocop:enable Rails/NotNullColumn
end
