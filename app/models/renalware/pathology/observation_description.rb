require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ObservationDescription < ActiveRecord::Base
      def self.for(codes)
        where(code: codes).order(indexed_case_stmt(:code, codes))
      end

      # Example:
      #
      #     indexed_case_stmt(:code, "DT", "AC", "XY")
      #
      # Will return the string:
      #
      #    CASE code
      #       WHEN 'DT' THEN 1
      #       WHEN 'AC' THEN 2
      #    END
      #
      # Used for creating an explicit sort order in conjustion with a find:
      #
      #    Description.where(code: codes).order(indexed_case_stmt(:code, codes))
      #
      def self.indexed_case_stmt(column, items)
        when_clauses = []
        items.each_with_index do |item, index|
          when_clauses << "WHEN '#{item}' THEN #{index}"
        end

        "CASE #{column} #{when_clauses.join} END"
      end

      def to_s
        code
      end
    end
  end
end
