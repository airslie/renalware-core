module Renalware::Heroic
  Rails.benchmark "Adding Heroic Study for BLT" do
    Renalware::Research::Study.find_or_create_by!(code: "HEROIC") do |study|
      study.started_on = Time.zone.today
      study.description = "Demo Heroic study"
      study.leader = "Thaddeus Gleichner"
      study.namespace = "::Research::Heroic"
      study.type = "Renalware::Heroic::Research::Study"
    end
  end
end
