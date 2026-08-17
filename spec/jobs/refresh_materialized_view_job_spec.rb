describe RefreshMaterializedViewJob do
  let(:connection) do
    instance_spy(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
  end

  before do
    allow(ActiveRecord::Base).to receive(:connection).and_return(connection)
  end

  it "quotes the materialized view name" do
    view_name = "renalware.reporting; DROP TABLE patients"
    quoted_view_name = '"renalware"."reporting; DROP TABLE patients"'
    allow(connection).to receive(:quote_table_name).with(view_name).and_return(quoted_view_name)

    described_class.perform_now(view_name:)

    expect(connection).to have_received(:execute)
      .with("REFRESH MATERIALIZED VIEW #{quoted_view_name};")
  end

  it "can refresh a materialized view concurrently" do
    view_name = "renalware.reporting_hd_overall_audit"
    quoted_view_name = '"renalware"."reporting_hd_overall_audit"'
    allow(connection).to receive(:quote_table_name).with(view_name).and_return(quoted_view_name)

    described_class.perform_now(view_name:, concurrently: true)

    expect(connection).to have_received(:execute)
      .with("REFRESH MATERIALIZED VIEW CONCURRENTLY #{quoted_view_name};")
  end

  it "refreshes all materialized views when no view name is supplied" do
    described_class.perform_now(view_name: nil)

    expect(connection).to have_received(:execute)
      .with("SELECT refresh_all_matierialized_views();")
  end
end
