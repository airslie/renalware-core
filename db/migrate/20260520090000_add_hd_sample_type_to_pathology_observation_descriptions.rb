class AddHDSampleTypeToPathologyObservationDescriptions < ActiveRecord::Migration[8.1]
  def change
    within_renalware_schema do
      create_enum :pathology_hd_sample_type, %w(pre post)

      safety_assured do
        change_table :pathology_observation_descriptions do |t|
          t.enum :hd_sample_type, enum_type: :pathology_hd_sample_type
        end
      end
    end
  end
end
