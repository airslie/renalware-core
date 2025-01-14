FactoryBot.define do
  factory :drug_trade_family, class: "Renalware::Drugs::TradeFamily" do
    sequence(:code) { "Code#{it}" }
  end
end
