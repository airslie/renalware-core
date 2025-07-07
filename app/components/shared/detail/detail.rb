# frozen_string_literal: true

module Shared
  class Detail < DescriptionList
    def initialize(record)
      @record = record
      @document = @record.document if @record.respond_to?(:document)

      super()
    end

    private

    attr_reader :record, :document
  end
end
