class AddFeatureFlagsToUsers < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column(
        :users,
        :feature_flags,
        :integer,
        default: 0,
        null: false,
        comment: "OR'ed feature flag bits to enable experimental features for certain users"
      )
    end
  end
end
