# frozen_string_literal: true

xml = builder

# From National MIM H=Home TMP=Temporary PST=Postal
xml.Address(use: "H") do
  # xml.FromTime address.created_at.to_date
  # xml.ToTime
  xml.Street address.street
  xml.Town address.town
  xml.County address.county
  xml.Postcode address.postcode
  xml.Country do
    xml.CodingStandard "ISO3166-1"
    xml.Code address&.country&.alpha3
    xml.Description address&.country&.to_s
  end
end
