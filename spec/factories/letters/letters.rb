FactoryGirl.define do
  factory :letter, class: "Renalware::Letters::Letter" do
    patient
    issued_on Time.zone.today
    state 'draft'
    body 'I met with Mrs. Brown last Tuesay and I am pleased to report a marked improvement in her condition.'
    # signature 'Dr. D.O. Good'

    association :author, factory: [:user, :author]

    trait(:ready_for_review) do
      state 'ready_for_review'
    end

    trait(:archived) do
      state 'archived'
    end

    # trait(:death) do
    #   letter_type 'death'
    # end

    # trait(:discharge) do
    #   letter_type 'discharge'
    # end

    # trait(:simple) do
    #   letter_type 'simple'
    # end
  end

  # factory :clinic_letter, class: "Renalware::Letters::ClinicLetter", parent: :letter do
  #   clinic_visit
  # end
end
