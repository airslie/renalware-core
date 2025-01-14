FactoryBot.define do
  factory :letter_topic, class: "Renalware::Letters::Topic" do
    sequence(:text) { "Text#{it}" }
  end
end
