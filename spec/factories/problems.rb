FactoryGirl.define do
  sequence :snomed_id do |n|
    n.to_s.rjust(8, '13456789')
  end

  factory :problem, class: "Renalware::Problem" do
    snomed_id
    description 'further description of the patient problem'
  end
end
