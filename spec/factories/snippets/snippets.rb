FactoryBot.define do
  factory :snippet, class: "Renalware::Authoring::Snippet" do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
    author factory: :snippets_user
  end
end
