# frozen_string_literal: true

module Renalware
  Rails.benchmark "Drug suppliers" do
    Drugs::Supplier.create!(name: "Generic")
    Drugs::Supplier.create!(name: "Fresenius")
  end
end
