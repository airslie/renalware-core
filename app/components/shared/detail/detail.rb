# frozen_string_literal: true

class Shared::Detail < Shared::DescriptionList
  def initialize(record)
    @record = record
    @document = @record.document if @record.respond_to?(:document)

    super()
  end

  private

  attr_reader :record, :document
end
