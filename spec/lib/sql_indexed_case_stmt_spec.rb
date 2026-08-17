describe SqlIndexedCaseStmt do
  describe "#generate" do
    subject(:sql) do
      statement = described_class.new(column, items).generate
      ActiveRecord::Base.connection.visitor.compile(statement)
    end

    let(:column) { :column }
    let(:items) { [:HGB, "PLT", "cre"] }

    it "quotes the column and values" do
      expect(sql).to eq(
        "CASE \"column\" WHEN 'HGB' THEN 0 WHEN 'PLT' THEN 1 WHEN 'cre' THEN 2 END"
      )
    end

    it "quotes qualified columns and escapes values containing quotes" do
      statement = described_class.new("patients.id", ["O'Hare"]).generate
      sql = ActiveRecord::Base.connection.visitor.compile(statement)

      expect(sql).to eq(
        "CASE \"patients\".\"id\" WHEN 'O''Hare' THEN 0 END"
      )
    end
  end
end
