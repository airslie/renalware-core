# frozen_string_literal: true

require "rails_helper"
require "rspec/expectations"

RSpec::Matchers.define :map_country do |from, to_country, to_region = nil|
  match do |mapper|
    result = mapper.map(from)
    result.country == to_country && result.region == to_region
  end
end

module Renalware
  module Feeds
    module Files
      describe Practices::CountryMap do
        UNITED_KINGDOM = "United Kingdom"
        it { is_expected.to map_country("ENGLAND", UNITED_KINGDOM, "England") }
        it { is_expected.to map_country("WALES", UNITED_KINGDOM, "Wales") }
        it { is_expected.to map_country("SCOTLAND", UNITED_KINGDOM, "Scotland") }
        it { is_expected.to map_country("NORTHERN IRELAND", UNITED_KINGDOM, "Northern Ireland") }
        it { is_expected.to map_country("Northern Ireland", UNITED_KINGDOM, "Northern Ireland") }
        it { is_expected.to map_country(" wales ", UNITED_KINGDOM, "Wales") }
        it { is_expected.to map_country("JERSEY", "JERSEY") }
      end
    end
  end
end
