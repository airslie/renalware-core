FactoryGirl.define do
  factory :letter do
    patient
    doctor
    state 'draft'
    letter_type 'clinic'
    letter_description
    recipient 'doctor'
    association :recipient_address, factory: :address
    body 'Dear Dr Sawr, I saw Mrs. Brown last Tuesay and I am pleased to report a marked improvement in her condition.'
    signature 'Dr. D.O. Good'
    association :author, factory: :user

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
end
