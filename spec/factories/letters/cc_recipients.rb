FactoryGirl.define do
  factory :letter_cc_recipient, class: "Renalware::Letters::Recipient" do
    role "cc"
  end
end
