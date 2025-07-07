# frozen_string_literal: true

module Renalware
  class Transplants::Detail::Review < Detail
    def initialize(_record)
      super(record: nil, fields: nil)
    end

    def view_template; end
  end
end
