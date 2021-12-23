class AddQhd33CodeToHDCannulationTypes < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column(
        :hd_cannulation_types,
        :qhd33_code,
        :string,
        comment: "Needling Method (RR50)"
      )
    end
  end
end
