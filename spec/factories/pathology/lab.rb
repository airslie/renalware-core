FactoryGirl.define do
  factory :pathology_lab, class: "Renalware::Pathology::Lab" do
    name %w(Biochemistry Microbiology Haemotology Virology).sample
  end
end
