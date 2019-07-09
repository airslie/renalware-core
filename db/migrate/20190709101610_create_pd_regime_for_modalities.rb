class CreatePDRegimeForModalities < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_view :pd_regime_for_modalities
    end
  end
end
