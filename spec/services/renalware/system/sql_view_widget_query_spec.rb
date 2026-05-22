module Renalware
  module System
    describe SqlViewWidgetQuery do
      subject(:query) { described_class.new(relation, connection: connection) }

      let(:relation) { instance_double(ActiveRecord::Relation, to_a: rows) }
      let(:rows) { [instance_double(ApplicationRecord)] }
      let(:connection) { instance_double(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter) }
      let(:executed_sql) { [] }

      before do
        allow(connection).to receive(:quote) { |value| "'#{value}'" }
        allow(connection).to receive(:transaction).with(requires_new: true).and_yield
        allow(connection).to receive(:execute) { |sql| executed_sql << sql }
      end

      it "loads the relation in a read-only transaction with short timeouts" do
        allow(connection).to receive(:transaction_open?).and_return(false)

        expect(query.call).to eq(rows)
        expect(executed_sql).to eq(
          [
            "SET TRANSACTION READ ONLY",
            "SET LOCAL statement_timeout = '5s'",
            "SET LOCAL lock_timeout = '500ms'"
          ]
        )
        expect(relation).to have_received(:to_a)
      end

      it "does not set read-only mode inside an existing transaction" do
        allow(connection).to receive(:transaction_open?).and_return(true)

        expect(query.call).to eq(rows)
        expect(executed_sql).to eq(
          [
            "SET LOCAL statement_timeout = '5s'",
            "SET LOCAL lock_timeout = '500ms'"
          ]
        )
        expect(relation).to have_received(:to_a)
      end
    end
  end
end
