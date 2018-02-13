class AddDisplayOrderColsToObservationDescriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :pathology_observation_descriptions,
               :display_order,
               :integer,
               index: :unique
    add_column :pathology_observation_descriptions,
               :display_order_letters,
               :integer,
               index: :unique
  end
end
