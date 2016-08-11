Given(/^the drugs:$/) do |table|
  table.hashes.each do |params|
    Renalware::Drugs::Drug.create!(params)
  end
end
