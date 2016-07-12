module Renalware
  Modalities::Description.find_or_create_by!(system_code: "death") do |description|
    description.system_code = "death"
    description.name = "Death"
  end

  Modalities::Description.find_or_create_by!(system_code: "live_donor") do |description|
    description.system_code = "live_donor"
    description.name = "Live Donor"
  end
end
