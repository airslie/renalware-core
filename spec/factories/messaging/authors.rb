FactoryGirl.define do
  factory :messaging_author,
          class: "Renalware::Messaging::Author",
          parent: :user
end
