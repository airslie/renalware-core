class AddLimitsToPathObsDescriptions < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column(
        :pathology_observation_descriptions,
        :lower_threshold,
        :float,
        comment: "Value below which a result can be seen as abnormal"
      )
      add_column(
        :pathology_observation_descriptions,
        :upper_threshold,
        :float,
        comment: "Value above which a result can be seen as abnormal"
      )
    end
  end
end
