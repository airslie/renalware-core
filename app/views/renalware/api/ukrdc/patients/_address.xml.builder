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
    xml.Code Renalware::Country.code_for(address.country)
    xml.Description address.country
  end
end
