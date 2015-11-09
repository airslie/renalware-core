FactoryGirl.define do
  factory :letter, class: "Renalware::Letter" do
    patient
    doctor
    state 'draft'
    letter_description
    recipient 'doctor'
    body 'I met with Mrs. Brown last Tuesay and I am pleased to report a marked improvement in her condition.'
    signature 'Dr. D.O. Good'
    association :recipient_address, factory: :address
    association :author, factory: [:user, :author]

    trait(:review) do
      state 'review'
    end

    trait(:death) do
      letter_type 'death'
    end

    trait(:discharge) do
      letter_type 'discharge'
    end

    trait(:simple) do
      letter_type 'simple'
    end
  end

  factory :clinic_letter, class: "Renalware::ClinicLetter", parent: :letter do
    clinic_visit
  end
end
