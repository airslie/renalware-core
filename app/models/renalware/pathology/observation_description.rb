require_dependency "renalware/pathology"
require 'sql/index_case_stmt'

module Renalware
  module Pathology
    class ObservationDescription < ActiveRecord::Base
      def self.for(codes)
        stmt = SQL::IndexedCaseStmt.new(:code, codes)
        where(code: codes).order(stmt.generate)
      end

      def to_s
        code
      end
    end
  end
end
