# frozen_string_literal: true

module Renalware
  module HD
    module Sessions
      class OngoingQuery
        def initialize(q: nil)
          @q = q || { s: "performed_on desc" }
        end

        def call
          search.result
        end

        def search
          @search ||= Session::Open.search(@q)
        end
      end
    end
  end
end
