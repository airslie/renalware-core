module Renalware
  class Patients::TimelineItem
    rattr_initialize :id, :date

    def type
      raise NotImplementedError
    end

    def description
      raise NotImplementedError
    end

    def detail
      ""
    end

    def created_by
      record.created_by.full_name
    end

    private

    def record
      @record ||= fetch.find(id)
    end

    def fetch
      raise NotImplementedError
    end
  end
end
