module Renalware
  module System
    class SqlViewWidgetQuery
      STATEMENT_TIMEOUT = "5s".freeze
      LOCK_TIMEOUT = "500ms".freeze

      attr_reader :relation, :connection

      def self.call(...) = new(...).call

      def initialize(relation, connection: ApplicationRecord.connection)
        @relation = relation
        @connection = connection
      end

      def call
        make_transaction_read_only = !connection.transaction_open?

        connection.transaction(requires_new: true) do
          connection.execute("SET TRANSACTION READ ONLY") if make_transaction_read_only
          connection.execute("SET LOCAL statement_timeout = #{connection.quote(STATEMENT_TIMEOUT)}")
          connection.execute("SET LOCAL lock_timeout = #{connection.quote(LOCK_TIMEOUT)}")

          relation.to_a
        end
      end
    end
  end
end
