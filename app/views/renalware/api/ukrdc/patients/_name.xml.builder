# frozen_string_literal: true

builder.Name(use: "L") do
  builder.Prefix nameable.title
  builder.Family nameable.family_name.strip
  builder.Given nameable.given_name.strip
  builder.Suffix nameable.suffix
end
