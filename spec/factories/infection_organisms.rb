FactoryGirl.define do
  factory :infection_organism, class: "Renalware::InfectionOrganism" do
    organism_code
    sensitivity "Sensitive to MRSA."
    infectable factory: :peritonitis_episode
    created_at "2015-03-03 15:30:00"
    updated_at "2015-03-05 15:30:00"
  end

end
