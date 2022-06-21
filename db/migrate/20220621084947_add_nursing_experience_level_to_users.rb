class AddNursingExperienceLevelToUsers < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      create_enum :nursing_experience_level_enum, %w(very_low low medium high very_high)

      add_column(
        :users,
        :nursing_experience_level,
        :nursing_experience_level_enum,
        null: true
      )
    end
  end
end
