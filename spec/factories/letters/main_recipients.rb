FactoryGirl.define do
  factory :letter_main_recipient, class: "Renalware::Letters::Recipient" do
    role "main"
  end
end
