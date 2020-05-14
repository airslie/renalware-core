# frozen_string_literal: true

module Renalware
  log "PD PET Dextrose Concentrations" do
    PD::PETDextroseConcentration.create!(name: "Dextrose 1.36%", position: 1)
    PD::PETDextroseConcentration.create!(name: "Dextrose 2.27%", position: 2)
    PD::PETDextroseConcentration.create!(name: "Dextrose 3.86%", position: 3)
    PD::PETDextroseConcentration.create!(name: "Extraneal", position: 4)
    PD::PETDextroseConcentration.create!(name: "Nutrineal", position: 5)
  end
end
