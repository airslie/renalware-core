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
          @search ||= QueryableSession.ongoing.search(@q)
        end

        private

        class QueryableSession < ActiveType::Record[Session]
          scope :ongoing, -> () {
            where.not(signed_on_by_id: nil)
              .where(signed_off_by_id: nil)
          }
        end
      end
    end
  end
end