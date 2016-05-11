FactoryGirl.define do
  factory :letter_recipient, class: "Renalware::Letters::Recipient" do
    trait :main do
      role "main"
    end

    trait :cc do
      role "cc"
    end
  end
end
