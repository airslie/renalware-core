FactoryBot.define do
  sequence(:term) { "term-#{it}" }
  factory :peritonitis_episode_type_description,
          class: "Renalware::PD::PeritonitisEpisodeTypeDescription" do
    term
    definition { Faker::Lorem.sentence }
  end
end
