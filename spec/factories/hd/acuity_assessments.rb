FactoryBot.define do
  factory :hd_acuity_assessment, class: "Renalware::HD::AcuityAssessment" do
    accountable
    patient { association(:patient, by: accountable_actor) }
    ratio { 0.25 }
  end
end
