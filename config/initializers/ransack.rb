# frozen_string_literal: true

Ransack.configure do |config|
  # Change default search parameter key name.
  # Default key name is :q
  # config.search_key = :query

  # Raise errors if a query contains an unknown predicate or attribute.
  # Default is true (do not raise error on unknown conditions).
  config.ignore_unknown_conditions = false

  # Globally display sort links without the order indicator arrow.
  # Default is false (sort order indicators are displayed).
  # This can also be configured individually in each sort link (see the README).
  # config.hide_sort_order_indicators = true
  #

  # Add a predicate to allow a datepicker for instance to find all items
  # with a certain created_at. It ensures the datetime is resolved as a date.
  # See
  # - https://github.com/activerecord-hackery/ransack/issues/101
  # - https://github.com/activerecord-hackery/ransack/wiki/Custom-Predicates
  config.add_predicate(
    "date_equals",
    arel_predicate: "eq",
    formatter: proc { |val| val&.to_date },
    validator: proc { |val| val.present? },
    type: :string
  )
end
