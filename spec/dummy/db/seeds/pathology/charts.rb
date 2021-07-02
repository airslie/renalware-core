# frozen_string_literal: true

module Renalware
  class ChartSeeder
    def create_chart_with(title, *obxcodes)
      Pathology::Charts::Chart.find_or_create_by!(title: title, scope: "charts").tap do |chart|
        obxcodes.each do |obx|
          chart.observation_descriptions << Pathology::ObservationDescription.find_by!(code: obx)
        end
      end
    end
  end

  log "Adding Pathology Charts" do
    seeder = ChartSeeder.new
    seeder.create_chart_with("HGB", "HGB")
    seeder.create_chart_with("Ferritin", "FER")
    seeder.create_chart_with("CRP", "CRP")
    seeder.create_chart_with("PTHI", "PTHI")
    seeder.create_chart_with("CAL PHOS", "CAL", "PHOS", "PRODUCT CA PHOS")
  end
end
