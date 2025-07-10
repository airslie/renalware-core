module Renalware
  class TimelineItem
    attr_reader :id, :sort_date, :record

    def initialize(id:, sort_date:)
      @id = id
      @sort_date = sort_date
    end

    def fetch
      @record = scope.find(id)
      self
    end

    private

    def scope
      raise NotImplementedError
    end
  end
end
