module Renalware::Heroic
  Rails.benchmark "Seeding default required renalware-heroic data" do
    require_relative "events/seeds"
    require_relative "clinics/clinics"
    require_relative "bio_bank/sample_types"
    require_relative "reports/definitions"
    require_relative "research/seeds"
  end
end
