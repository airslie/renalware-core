RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

# Use this strategy to get Hash output from factories defined using class: OpenStruct.
# Useful for working with jsonb-based Document objects.
#
# Example usage
#
#  factory :some_document, class: OpenStruct do
#    pulse 37
#  end
#
#  factory :something do
#   document factory: :some_document, strategy: :marshal_dump
#  end
#
class MarshalDumpStrategy
  def initialize
    @strategy = FactoryGirl.strategy_by_name(:create).new
  end

  delegate :association, to: :@strategy

  def result(evaluation)
    @strategy.result(evaluation).marshal_dump
  end
end
FactoryGirl.register_strategy(:marshal_dump, MarshalDumpStrategy)
